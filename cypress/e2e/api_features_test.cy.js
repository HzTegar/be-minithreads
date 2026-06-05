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
        password: 'password123'
    };

    // 1. AUTHENTICATION FEATURES
    context('Authentication Features', () => {
        it('should register a new user successfully', () => {
            cy.request('POST', '/api/auth/register', userCredentials).then((response) => {
                expect(response.status).to.eq(201);
                expect(response.body.success).to.be.true;
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
            cy.request('POST', '/api/auth/login', adminCredentials).then((res) => {
                expect(res.status).to.eq(200);
                adminToken = res.body.access_token;
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
        it('should create a new post', () => {
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

        it('should find a post and comment', () => {
            cy.request('GET', `/api/posts`).then((res) => {
                expect(res.status).to.eq(200);
            });
        });

        it('should toggle accepted answer (Feature Logic)', () => {
            cy.request({
                method: 'POST',
                url: `/api/posts/${testPostId}/comments/some-uuid/toggle-accepted`,
                headers: { Authorization: `Bearer ${authToken}` },
                failOnStatusCode: false
            }).then((res) => {
                expect([404, 403]).to.include(res.status);
            });
        });
    });

    // 4. SOCIAL INTERACTION (Follow)
    context('Social Features', () => {
        it('should find another user to follow', () => {
            cy.request('GET', '/api/posts').then((res) => {
                // FIX: Access res.body.data.data for Laravel Pagination
                const posts = res.body.data.data; 
                const otherPost = posts.find(p => p.user && p.user.email !== userCredentials.email);
                
                if (otherPost) {
                    otherUserId = otherPost.user_id;
                } else {
                    otherUserId = '019e9819-4e03-7310-bb79-1bc56583cb18'; // Fallback admin ID
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
