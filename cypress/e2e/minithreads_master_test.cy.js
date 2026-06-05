describe('MiniThreads Definitive Master Test', () => {
  const baseUrl = 'http://localhost:8000/api';

  // Global states for IDs and Tokens
  let adminToken, userToken, authToken;
  let categoryId, postId, commentId, otherUserId;

  const adminCreds = { email: 'admin@minithreads.com', password: 'password123' };
  const userCreds = { email: 'user@minithreads.com', password: 'password123' };
  const newUser = {
    username: `tester_${Date.now()}`,
    email: `tester_${Date.now()}@example.com`,
    password: 'password123',
    password_confirmation: 'password123'
  };

  /**
   * SECTION 1: AUTHENTICATION & PROFILE
   */
  context('01. Authentication & Profile', () => {
    it('Should register, login, and update profile', () => {
      // 1. Register
      cy.request('POST', `${baseUrl}/auth/register`, newUser).then((res) => {
        expect(res.status).to.eq(201);
      });

      // 2. Login New User
      cy.request('POST', `${baseUrl}/auth/login`, {
        email: newUser.email,
        password: newUser.password
      }).then((res) => {
        expect(res.status).to.eq(200);
        authToken = res.body.access_token;

        // 3. Update Profile (Bio)
        cy.request({
          method: 'POST',
          url: `${baseUrl}/profile/update`,
          headers: { Authorization: `Bearer ${authToken}` },
          body: { bio: 'This is my new bio from Cypress master test.' }
        }).then((profileRes) => {
          expect(profileRes.status).to.eq(200);
          expect(profileRes.body.user.bio).to.contain('Cypress master test');
        });

        // 4. Check Profile Me
        cy.request({
          method: 'GET',
          url: `${baseUrl}/auth/me`,
          headers: { Authorization: `Bearer ${authToken}` }
        }).then((meRes) => {
          expect(meRes.body.user.email).to.eq(newUser.email);
        });
      });
    });

    it('Should login as fixed Admin and User for further testing', () => {
      cy.request('POST', `${baseUrl}/auth/login`, adminCreds).then((res) => {
        adminToken = res.body.access_token;
      });
      cy.request('POST', `${baseUrl}/auth/login`, userCreds).then((res) => {
        userToken = res.body.access_token;
      });
    });
  });

  /**
   * SECTION 2: CATEGORIES & TAGS
   */
  context('02. Categories & Tags', () => {
    it('Should handle categories (CRUD roles)', () => {
      // 1. List Categories
      cy.request('GET', `${baseUrl}/categories`).then((res) => {
        expect(res.status).to.eq(200);
        expect(res.body.data).to.be.an('array');
      });

      // 2. Create Category (Admin Only) - Unique name to avoid 422
      cy.request({
        method: 'POST',
        url: `${baseUrl}/categories`,
        headers: { Authorization: `Bearer ${adminToken}` },
        body: { 
            name: 'Master Category ' + Date.now(), 
            slug: 'master-cat-' + Date.now(),
            description: 'Created by Master Test'
        }
      }).then((res) => {
        expect(res.status).to.eq(201);
        categoryId = res.body.data.id;

        // 3. Update Category (Moderator/Admin)
        cy.request({
          method: 'PUT',
          url: `${baseUrl}/categories/${categoryId}`,
          headers: { Authorization: `Bearer ${adminToken}` },
          body: { name: 'Updated Master Category ' + Date.now() }
        }).then((updateRes) => {
          expect(updateRes.status).to.eq(200);
        });

        // 4. List Tags
        cy.request('GET', `${baseUrl}/tags`).then((tagRes) => {
          expect(tagRes.status).to.eq(200);
        });
      });
    });
  });

  /**
   * SECTION 3: CORE FORUM LOGIC (Posts & Comments)
   */
  context('03. Core Forum Logic', () => {
    it('Should handle Post creation, Edit Limits (3x), and Filtering', () => {
      // 1. Create Post with Auto-tagging
      cy.request({
        method: 'POST',
        url: `${baseUrl}/posts`,
        headers: { Authorization: `Bearer ${userToken}` },
        body: {
          category_id: categoryId,
          title: 'Master Question Logic',
          body: 'Content for master testing logic.',
          tags: ['cypress', 'laravel', 'logic-master'] 
        }
      }).then((res) => {
        expect(res.status).to.eq(201);
        postId = res.body.data.id;

        // 2. Perform 3 Edits (Log History)
        for (let i = 1; i <= 3; i++) {
          cy.request({
            method: 'PUT',
            url: `${baseUrl}/posts/${postId}`,
            headers: { Authorization: `Bearer ${userToken}` },
            body: { category_id: categoryId, title: `Title Edit ${i}`, body: '...' }
          });
        }

        // 3. Edit 4 Must Fail
        cy.request({
          method: 'PUT',
          url: `${baseUrl}/posts/${postId}`,
          headers: { Authorization: `Bearer ${userToken}` },
          body: { title: 'Illegal' },
          failOnStatusCode: false
        }).then((failRes) => {
          expect(failRes.status).to.eq(400);
        });

        // 4. Test Filtering by Category
        cy.request('GET', `${baseUrl}/posts?category_id=${categoryId}`).then((filterRes) => {
            expect(filterRes.status).to.eq(200);
            expect(filterRes.body.data.data.length).to.be.at.least(1);
        });
      });
    });

    it('Should handle Comments, Replies, and Owner Limit (4x)', () => {
      // 1. Create Comment
      cy.request({
        method: 'POST',
        url: `${baseUrl}/posts/${postId}/comments`,
        headers: { Authorization: `Bearer ${userToken}` },
        body: { body: 'Master Comment' }
      }).then((res) => {
        commentId = res.body.data.id;

        // 2. Edit Comment (Limit 1x)
        cy.request({
          method: 'PUT',
          url: `${baseUrl}/comments/${commentId}`,
          headers: { Authorization: `Bearer ${userToken}` },
          body: { body: 'Edited Master Comment' }
        }).then((editRes) => {
          expect(editRes.body.data.status).to.eq('edited');
        });

        // 3. Edit Again Fail
        cy.request({
          method: 'PUT',
          url: `${baseUrl}/comments/${commentId}`,
          headers: { Authorization: `Bearer ${userToken}` },
          body: { body: 'Fail' },
          failOnStatusCode: false
        }).then((f) => expect(f.status).to.eq(400));

        // 4. Owner Comment Limit (Total 4)
        for (let i = 2; i <= 4; i++) {
            cy.request({
                method: 'POST',
                url: `${baseUrl}/posts/${postId}/comments`,
                headers: { Authorization: `Bearer ${userToken}` },
                body: { body: `Owner Comment ${i}` }
            });
        }
        
        // 5. Comment 5 Fail
        cy.request({
            method: 'POST',
            url: `${baseUrl}/posts/${postId}/comments`,
            headers: { Authorization: `Bearer ${userToken}` },
            body: { body: 'Fail 5' },
            failOnStatusCode: false
        }).then((res5) => {
            expect(res5.status).to.eq(400);
            expect(res5.body.message).to.contain('Batas komentar tercapai');
        });

        // 6. Toggle Accepted Answer
        cy.request({
          method: 'POST',
          url: `${baseUrl}/posts/${postId}/comments/${commentId}/toggle-accepted`,
          headers: { Authorization: `Bearer ${userToken}` }
        }).then((acc) => {
          expect(acc.body.data.is_accepted).to.be.true;
        });
      });
    });
  });

  /**
   * SECTION 4: SOCIAL, AUDIT & DELETION
   */
  context('04. Social, Audit & Deletion Logic', () => {
    it('Should follow others and check history visibility', () => {
      // 1. Follow dynamically (Avoid self-follow)
      cy.request({ method: 'GET', url: `${baseUrl}/auth/me`, headers: { Authorization: `Bearer ${userToken}` } })
        .then((me) => {
          const myId = me.body.user.id;
          cy.request('GET', `${baseUrl}/posts`).then((res) => {
            const other = res.body.data.data.find(p => p.user_id !== myId);
            if (other) {
              cy.request({ 
                method: 'POST', 
                url: `${baseUrl}/user/follow/${other.user_id}`, 
                headers: { Authorization: `Bearer ${userToken}` } 
              }).then(f => expect(f.status).to.eq(200));
            }
          });
        });

      // 2. Audit History Visibility (Admin only)
      cy.request({ method: 'GET', url: `${baseUrl}/posts/${postId}`, headers: { Authorization: `Bearer ${adminToken}` } })
        .then((res) => {
            expect(res.body.data).to.have.property('edit_histories');
        });
      
      cy.request({ method: 'GET', url: `${baseUrl}/posts/${postId}`, headers: { Authorization: `Bearer ${userToken}` } })
        .then((res) => {
            expect(res.body.data).to.not.have.property('edit_histories');
        });
    });

    it('Should distinguish Soft Delete and Hard Delete', () => {
      // 1. User Soft Delete
      cy.request({
        method: 'POST',
        url: `${baseUrl}/posts`,
        headers: { Authorization: `Bearer ${userToken}` },
        body: { category_id: categoryId, title: 'Temporary Post', body: '...' }
      }).then((res) => {
        cy.request({ 
            method: 'DELETE', 
            url: `${baseUrl}/posts/${res.body.data.id}`, 
            headers: { Authorization: `Bearer ${userToken}` } 
        }).then((d) => expect(d.body.message).to.contain('Soft Delete'));
      });

      // 2. Admin Hard Delete
      cy.request({
        method: 'DELETE',
        url: `${baseUrl}/posts/${postId}`,
        headers: { Authorization: `Bearer ${adminToken}` }
      }).then((d) => expect(d.body.message).to.contain('PERMANEN'));
    });
  });

  /**
   * SECTION 5: INTERACTIVE (VOTING & REPUTATION)
   */
  context('05. Voting & Reputation', () => {
    it('Should handle Voting on Post and Comment', () => {
        // Create fresh post for voting (previous was deleted)
        cy.request({
            method: 'POST',
            url: `${baseUrl}/posts`,
            headers: { Authorization: `Bearer ${adminToken}` }, // Admin creates it
            body: { category_id: categoryId, title: 'Vote Target', body: '...' }
          }).then((postRes) => {
            const vPostId = postRes.body.data.id;
            
            // 1. User votes on Admin's post (Upvote)
            cy.request({
                method: 'POST',
                url: `${baseUrl}/vote`,
                headers: { Authorization: `Bearer ${userToken}` },
                body: { target_id: vPostId, target_type: 'post', vote_type: 'up' }
            }).then((v) => {
                expect(v.status).to.eq(201);
                expect(v.body.vote_score).to.eq(1);
            });

            // 2. User votes on Comment (if any)
            cy.request({
                method: 'POST',
                url: `${baseUrl}/posts/${vPostId}/comments`,
                headers: { Authorization: `Bearer ${adminToken}` },
                body: { body: 'Vote my comment' }
            }).then((cRes) => {
                const vCommentId = cRes.body.data.id;
                cy.request({
                    method: 'POST',
                    url: `${baseUrl}/vote`,
                    headers: { Authorization: `Bearer ${userToken}` },
                    body: { target_id: vCommentId, target_type: 'comment', vote_type: 'down' }
                }).then((v2) => {
                    expect(v2.status).to.eq(201);
                    expect(v2.body.vote_score).to.eq(-1);
                });
            });
          });
    });
  });

  /**
   * SECTION 6: LOGOUT
   */
  context('06. Logout', () => {
    it('Should logout successfully', () => {
      cy.request({
        method: 'POST',
        url: `${baseUrl}/auth/logout`,
        headers: { Authorization: `Bearer ${userToken}` }
      }).then((res) => {
        expect(res.status).to.eq(200);
      });
    });
  });
});
