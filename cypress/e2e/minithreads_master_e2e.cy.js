describe('MiniThreads Master E2E Test Suite', () => {
    const baseUrl = 'http://localhost:8000/api';
    const timestamp = Date.now();
    const user1 = {
        username: `u1_${timestamp}`,
        email: `u1_${timestamp}@test.com`,
        password: 'password123',
        password_confirmation: 'password123'
    };
    const user2 = {
        username: `u2_${timestamp}`,
        email: `u2_${timestamp}@test.com`,
        password: 'password123',
        password_confirmation: 'password123'
    };
    const admin = {
        email: 'admin@minithreads.com',
        password: 'password123'
    };

    it('Executes Full Lifecycle Test', () => {
        // 1. Auth: Register & Login
        cy.request('POST', `${baseUrl}/auth/register`, user1).then(() => {
            cy.request('POST', `${baseUrl}/auth/register`, user2).then(() => {
                cy.request('POST', `${baseUrl}/auth/login`, { email: user1.email, password: user1.password }).then((res1) => {
                    const token1 = res1.body.access_token;
                    
                    cy.request('POST', `${baseUrl}/auth/login`, { email: user2.email, password: user2.password }).then((res2) => {
                        const token2 = res2.body.access_token;
                        
                        cy.request('POST', `${baseUrl}/auth/login`, { email: admin.email, password: admin.password }).then((resA) => {
                            const tokenAdmin = resA.body.access_token;

                            // 2. Profile & Social
                            cy.request({
                                method: 'POST',
                                url: `${baseUrl}/profile/update`,
                                headers: { Authorization: `Bearer ${token1}` },
                                body: { bio: 'Updated bio' }
                            });

                            cy.request({
                                method: 'GET',
                                url: `${baseUrl}/auth/me`,
                                headers: { Authorization: `Bearer ${token1}` }
                            }).then(me1 => {
                                const user1Id = me1.body.user.id;
                                cy.request({
                                    method: 'POST',
                                    url: `${baseUrl}/user/follow/${user1Id}`,
                                    headers: { Authorization: `Bearer ${token2}` }
                                });
                            });

                            // 3. Categories & Posts
                            cy.request({
                                method: 'POST',
                                url: `${baseUrl}/categories`,
                                headers: { Authorization: `Bearer ${tokenAdmin}` },
                                body: { name: `Cat ${timestamp}`, description: 'Desc' }
                            }).then(catRes => {
                                const categoryId = catRes.body.data.id;

                                // BIAR USER1 PUNYA POIN (MINIMAL 20) UNTUK POSTING
                                // Admin buat 2 post pancingan
                                cy.request({
                                    method: 'POST',
                                    url: `${baseUrl}/posts`,
                                    headers: { Authorization: `Bearer ${tokenAdmin}` },
                                    body: { category_id: categoryId, title: 'Bait 1', body: '...' }
                                }).then(p1 => {
                                    cy.request({ method: 'POST', url: `${baseUrl}/like`, headers: { Authorization: `Bearer ${token1}` }, body: { target_id: p1.body.data.id, target_type: 'post' } });
                                    cy.request({ method: 'POST', url: `${baseUrl}/vote`, headers: { Authorization: `Bearer ${token1}` }, body: { target_id: p1.body.data.id, target_type: 'post', vote_type: 'up' } });
                                });
                                cy.request({
                                    method: 'POST',
                                    url: `${baseUrl}/posts`,
                                    headers: { Authorization: `Bearer ${tokenAdmin}` },
                                    body: { category_id: categoryId, title: 'Bait 2', body: '...' }
                                }).then(p2 => {
                                    cy.request({ method: 'POST', url: `${baseUrl}/like`, headers: { Authorization: `Bearer ${token1}` }, body: { target_id: p2.body.data.id, target_type: 'post' } });
                                });

                                cy.request({
                                    method: 'POST',
                                    url: `${baseUrl}/posts`,
                                    headers: { Authorization: `Bearer ${token1}` },
                                    body: {
                                        category_id: categoryId,
                                        title: 'Cypress Test Post',
                                        body: 'Testing content',
                                        tags: ['cypress', 'test']
                                    }
                                }).then(postRes => {
                                    const postId = postRes.body.data.id;

                                    // 4. Interactions (Like, Vote, Bookmark)
                                    cy.request({
                                        method: 'POST',
                                        url: `${baseUrl}/like`,
                                        headers: { Authorization: `Bearer ${token2}` },
                                        body: { target_id: postId, target_type: 'post' }
                                    });

                                    cy.request({
                                        method: 'POST',
                                        url: `${baseUrl}/vote`,
                                        headers: { Authorization: `Bearer ${token2}` },
                                        body: { target_id: postId, target_type: 'post', vote_type: 'up' }
                                    });

                                    cy.request({
                                        method: 'POST',
                                        url: `${baseUrl}/posts/${postId}/bookmark`,
                                        headers: { Authorization: `Bearer ${token2}` }
                                    });

                                    // 5. Discussion & Accepted Answer
                                    cy.request({
                                        method: 'POST',
                                        url: `${baseUrl}/posts/${postId}/comments`,
                                        headers: { Authorization: `Bearer ${token2}` },
                                        body: { body: 'Answer from User 2' }
                                    }).then(commRes => {
                                        const commentId = commRes.body.data.id;

                                        cy.request({
                                            method: 'POST',
                                            url: `${baseUrl}/posts/${postId}/comments/${commentId}/toggle-accepted`,
                                            headers: { Authorization: `Bearer ${token1}` }
                                        });

                                        // 6. Verify Reputation
                                        cy.request({
                                            method: 'GET',
                                            url: `${baseUrl}/auth/me`,
                                            headers: { Authorization: `Bearer ${token2}` }
                                        }).then(me2 => {
                                            expect(me2.body.user.reputation_points).to.be.at.least(15);
                                            expect(me2.body.user.rank_level).to.exist;
                                        });
                                    });

                                    // 7. Search & Notifications
                                    cy.request('GET', `${baseUrl}/search/global?keyword=Cypress`);
                                    cy.request({
                                        method: 'GET',
                                        url: `${baseUrl}/notifications`,
                                        headers: { Authorization: `Bearer ${token2}` }
                                    });

                                    // 8. Reporting
                                    cy.request({
                                        method: 'POST',
                                        url: `${baseUrl}/reports`,
                                        headers: { Authorization: `Bearer ${token2}` },
                                        body: { target_id: postId, target_type: 'post', reason: 'Spam' }
                                    }).then(repRes => {
                                        const reportId = repRes.body.data.id;
                                        cy.request({
                                            method: 'PUT',
                                            url: `${baseUrl}/admin/reports/${reportId}`,
                                            headers: { Authorization: `Bearer ${tokenAdmin}` },
                                            body: { status: 'resolved', moderator_notes: 'Closed' }
                                        });
                                    });

                                    // 9. Cleanup (Delete)
                                    cy.request({
                                        method: 'DELETE',
                                        url: `${baseUrl}/posts/${postId}`,
                                        headers: { Authorization: `Bearer ${token1}` }
                                    });
                                });
                            });
                        });
                    });
                });
            });
        });
    });
});
