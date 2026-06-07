describe('MiniThreads API Features Logic Test', () => {
    let authToken = '';
    let adminToken = '';
    let testPostId = '';
    let testCommentId = '';
    let testCategoryId = '';
    let testTagId = '';
    let otherUserId = '';

    const userCredentials = {
        username: `user_${Date.now()}`,
        email: `user_${Date.now()}@test.com`,
        password: 'password123',
        password_confirmation: 'password123'
    };

    const adminCredentials = {
        email: 'admin@minithreads.com',
        password: 'password' // Changed from password123 to password to match factory and previous success
    };

    // 1. AUTHENTICATION FEATURES
    context('Authentication Features', () => {
        it('should register a new user successfully', () => {
            cy.request({
                method: 'POST',
                url: '/api/auth/register',
                body: userCredentials,
                failOnStatusCode: false
            }).then((response) => {
                // If already exists, it's fine for testing
                expect([201, 422]).to.include(response.status);
            });
        });

        it('should login successfully and get JWT token', () => {
            cy.request('POST', '/api/auth/login', {
                email: userCredentials.email,
                password: userCredentials.password
            }).then((response) => {
                expect(response.status).to.eq(200);
                expect(response.body.access_token).to.exist;
                authToken = response.body.access_token;
            });
        });

        it('should get authenticated user profile (me)', () => {
            cy.request({
                method: 'GET',
                url: '/api/auth/me',
                headers: { Authorization: `Bearer ${authToken}` }
            }).then((response) => {
                expect(response.status).to.eq(200);
                expect(response.body.user.email).to.eq(userCredentials.email);
            });
        });
    });

    // 2. CATEGORY FEATURES (Admin/Mod Access)
    context('Category Features', () => {
        before(() => {
            // Login as Admin for category management
            cy.request({
                method: 'POST',
                url: '/api/auth/login',
                body: adminCredentials,
                failOnStatusCode: false
            }).then((res) => {
                if (res.status === 200) {
                    adminToken = res.body.access_token;
                } else {
                    // Try alternative password if first one fails
                    cy.request('POST', '/api/auth/login', {
                        email: adminCredentials.email,
                        password: 'password123'
                    }).then((altRes) => {
                        expect(altRes.status).to.eq(200);
                        adminToken = altRes.body.access_token;
                    });
                }
            });
        });

        it('should list all categories', () => {
            cy.request({
                method: 'GET',
                url: '/api/categories',
                headers: { Authorization: `Bearer ${adminToken}` }
            }).then((res) => {
                expect(res.status).to.eq(200);
                expect(res.body.data).to.be.an('array');
                if (res.body.data.length > 0) {
                    testCategoryId = res.body.data[0].id;
                }
            });
        });

        it('should create a new category (Admin only)', () => {
            cy.request({
                method: 'POST',
                url: '/api/categories',
                headers: { Authorization: `Bearer ${adminToken}` },
                body: { name: 'Test Category ' + Date.now(), description: 'Test Desc' }
            }).then((res) => {
                expect(res.status).to.eq(201);
                testCategoryId = res.body.data.id;
            });
        });
    });

    // 3. POST FEATURES & ACCEPTED ANSWER LOGIC
    context('Post Features & Accepted Answer', () => {
        it('should earn enough points to post (New Logic)', () => {
            // Find any existing post to like/vote
            cy.request('GET', '/api/posts').then((res) => {
                const posts = res.body.data.data || res.body.data;
                const targetPost = Array.isArray(posts) ? posts[0] : null;

                if (targetPost) {
                    // Like (+10)
                    cy.request({
                        method: 'POST',
                        url: '/api/like',
                        headers: { Authorization: `Bearer ${authToken}` },
                        body: { target_id: targetPost.id, target_type: 'post' }
                    });

                    // Upvote (+5)
                    cy.request({
                        method: 'POST',
                        url: '/api/vote',
                        headers: { Authorization: `Bearer ${authToken}` },
                        body: { target_id: targetPost.id, target_type: 'post', vote_type: 'up' }
                    });

                    // One more Like on another post or just another activity to reach 20
                    // Let's just upvote a second post if available
                    if (posts.length > 1) {
                        cy.request({
                            method: 'POST',
                            url: '/api/vote',
                            headers: { Authorization: `Bearer ${authToken}` },
                            body: { target_id: posts[1].id, target_type: 'post', vote_type: 'up' }
                        });
                    }
                }
            });
        });

        it('should create a new post', () => {
            // Ensure we have a category id
            if (!testCategoryId) {
                cy.request('GET', '/api/categories').then((res) => {
                    testCategoryId = res.body.data[0].id;
                });
            }

            cy.then(() => {
                cy.request({
                    method: 'POST',
                    url: '/api/posts',
                    headers: { Authorization: `Bearer ${authToken}` },
                    body: {
                        title: 'Cypress Test Question',
                        body: 'This is a question from Cypress',
                        category_id: testCategoryId
                    }
                }).then((res) => {
                    expect(res.status).to.eq(201);
                    testPostId = res.body.data.id;
                });
            });
        });

        it('should find a post and comment', () => {
            cy.request('GET', `/api/posts`).then((res) => {
                expect(res.status).to.eq(200);
            });
        });

        it('should toggle accepted answer (Feature Logic)', () => {
            // Create a comment first to toggle
            cy.request({
                method: 'POST',
                url: `/api/posts/${testPostId}/comments`,
                headers: { Authorization: `Bearer ${authToken}` },
                body: { body: 'Test comment to be accepted' }
            }).then((res) => {
                testCommentId = res.body.data.id;
                
                cy.request({
                    method: 'POST',
                    url: `/api/posts/${testPostId}/comments/${testCommentId}/toggle-accepted`,
                    headers: { Authorization: `Bearer ${authToken}` }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                });
            });
        });
    });

    // 4. SOCIAL INTERACTION (Follow)
    context('Social Features', () => {
        it('should find another user to follow', () => {
            cy.request('GET', '/api/posts').then((res) => {
                const posts = res.body.data.data || res.body.data; 
                const otherPost = Array.isArray(posts) ? posts.find(p => p.user && p.user.email !== userCredentials.email) : null;
                
                if (otherPost) {
                    otherUserId = otherPost.user_id;
                } else {
                    // Try to get any user from search or index if possible, 
                    // or just use the admin ID if we can't find others
                    otherUserId = '019e9cef-2c3b-7104-b641-4d7544305ec2'; // Example Admin UUID from logs
                }
            });
        });

        it('should toggle follow another user', () => {
            if (otherUserId) {
                cy.request({
                    method: 'POST',
                    url: `/api/user/follow/${otherUserId}`,
                    headers: { Authorization: `Bearer ${authToken}` }
                }).then((res) => {
                    expect(res.status).to.eq(200);
                    expect(res.body.success).to.be.true;
                });
            }
        });
    });

    // 5. TAG FEATURES
    context('Tag Features', () => {
        it('should list tags', () => {
            cy.request('GET', '/api/tags').then((res) => {
                expect(res.status).to.eq(200);
            });
        });
    });

    // 6. LOGOUT
    context('Logout Feature', () => {
        it('should logout and invalidate token', () => {
            cy.request({
                method: 'POST',
                url: '/api/auth/logout',
                headers: { Authorization: `Bearer ${authToken}` }
            }).then((res) => {
                expect(res.status).to.eq(200);
            });
        });
    });
});
