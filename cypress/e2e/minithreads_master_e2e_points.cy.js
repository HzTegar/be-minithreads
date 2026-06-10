describe('MiniThreads Master API & Point System Test', () => {
  const baseUrl = 'http://localhost:8000/api';
  
  // Variables for dynamic data
  let adminToken;
  let newbieToken;
  let newbieId;
  let categoryId;
  let postId;
  let commentId;

  // New User Credentials
  const newbieCreds = {
    username: 'newbie_' + Date.now(),
    email: 'newbie_' + Date.now() + '@example.com',
    password: 'password123',
    password_confirmation: 'password123'
  };

  const adminCreds = { email: 'admin@minithreads.com', password: 'password123' };

  /**
   * 1. SETUP: ADMIN LOGIN & CREATE CATEGORY
   */
  it('01. Setup: Admin Auth & Category Preparation', () => {
    cy.request('POST', `${baseUrl}/auth/login`, adminCreds).then((res) => {
      adminToken = res.body.access_token;
      
      // Create Category for testing
      cy.request({
        method: 'POST',
        url: `${baseUrl}/categories`,
        headers: { Authorization: `Bearer ${adminToken}` },
        body: { 
          name: 'Cypress Testing ' + Date.now(), 
          slug: 'cypress-test-' + Date.now(),
          description: 'Category for Cypress testing'
        }
      }).then((catRes) => {
        categoryId = catRes.body.data.id;
      });
    });
  });

  /**
   * 2. USER REGISTRATION & INITIAL POINT RESTRICTION
   */
  it('02. User Flow: Register & Verify Point Restriction', () => {
    // Register New User
    cy.request('POST', `${baseUrl}/auth/register`, newbieCreds).then((res) => {
      expect(res.status).to.eq(201);
      newbieToken = res.body.access_token;
      newbieId = res.body.user.id;

      // Verify initial points are 0 and rank is Bronze
      cy.request({
        method: 'GET',
        url: `${baseUrl}/auth/me`,
        headers: { Authorization: `Bearer ${newbieToken}` }
      }).then((meRes) => {
        expect(meRes.body.user.reputation_points).to.eq(0);
        expect(meRes.body.user.rank_level).to.eq('Bronze');
      });

      // Try to Post (Must Fail - 403 Forbidden)
      cy.request({
        method: 'POST',
        url: `${baseUrl}/posts`,
        headers: { Authorization: `Bearer ${newbieToken}` },
        body: {
          category_id: categoryId,
          title: 'Post Ilegal Newbie',
          body: 'Harusnya gagal karena poin cuma 0',
          tags: ['test']
        },
        failOnStatusCode: false
      }).then((postRes) => {
        expect(postRes.status).to.eq(403);
        expect(postRes.body.message).to.contain('Poin kamu belum cukup');
      });
    });
  });

  /**
   * 3. EARNING POINTS: VOTE & LIKE
   */
  it('03. User Flow: Earning Points through Activity', () => {
    // 1. Need an existing post to interact with (Use admin post or create one)
    cy.request({
      method: 'POST',
      url: `${baseUrl}/posts`,
      headers: { Authorization: `Bearer ${adminToken}` },
      body: {
        category_id: categoryId,
        title: 'Post Target Aktivitas',
        body: 'Silahkan like dan vote post ini',
        tags: ['target']
      }
    }).then((postRes) => {
      const targetPostId = postRes.body.data.id;

      // Activity A: Like Post (+10 Points)
      cy.request({
        method: 'POST',
        url: `${baseUrl}/like`,
        headers: { Authorization: `Bearer ${newbieToken}` },
        body: { target_id: targetPostId, target_type: 'post' }
      }).then((likeRes) => {
        expect(likeRes.status).to.eq(201);
      });

      // Activity B: Upvote Post (+5 Points)
      cy.request({
        method: 'POST',
        url: `${baseUrl}/vote`,
        headers: { Authorization: `Bearer ${newbieToken}` },
        body: { target_id: targetPostId, target_type: 'post', vote_type: 'up' }
      }).then((voteRes) => {
        expect(voteRes.status).to.eq(201);
      });

      // Activity C: Downvote Post (-5 Points) - Just to test logic
      cy.request({
        method: 'POST',
        url: `${baseUrl}/vote`,
        headers: { Authorization: `Bearer ${newbieToken}` },
        body: { target_id: targetPostId, target_type: 'post', vote_type: 'down' }
      }).then((voteRes) => {
        expect(voteRes.status).to.eq(200); // Because we switch from up to down
      });

      // Activity D: Switch back to Upvote (+5 from cancelling down, +5 from new up = +10)
      cy.request({
        method: 'POST',
        url: `${baseUrl}/vote`,
        headers: { Authorization: `Bearer ${newbieToken}` },
        body: { target_id: targetPostId, target_type: 'post', vote_type: 'up' }
      }).then((voteRes) => {
        expect(voteRes.status).to.eq(200);
      });

      // Total Points should be: 10 (like) + 5 (upvote) = 15. Still not enough.
      // Need 5 more points. Upvote another post/comment.
      
      // Create another post for more points
      cy.request({
        method: 'POST',
        url: `${baseUrl}/posts`,
        headers: { Authorization: `Bearer ${adminToken}` },
        body: { category_id: categoryId, title: 'Post Target 2', body: 'Target points', tags: ['target'] }
      }).then((post2Res) => {
        const targetPost2Id = post2Res.body.data.id;
        
        cy.request({
          method: 'POST',
          url: `${baseUrl}/vote`,
          headers: { Authorization: `Bearer ${newbieToken}` },
          body: { target_id: targetPost2Id, target_type: 'post', vote_type: 'up' }
        });
      });

      // Now verify points are >= 20 and rank is Silver
      cy.request({
        method: 'GET',
        url: `${baseUrl}/auth/me`,
        headers: { Authorization: `Bearer ${newbieToken}` }
      }).then((meRes) => {
        expect(meRes.body.user.reputation_points).to.be.at.least(20);
        expect(meRes.body.user.rank_level).to.eq('Silver');
      });
    });
  });

  /**
   * 4. POSTING & EDITING (POINT THRESHOLD MET)
   */
  it('04. Post Logic: Create & 3-Edit Limit', () => {
    // 1. Create Post (Now it should succeed)
    cy.request({
      method: 'POST',
      url: `${baseUrl}/posts`,
      headers: { Authorization: `Bearer ${newbieToken}` },
      body: {
        category_id: categoryId,
        title: 'Pertanyaan Newbie Berprestasi',
        body: 'Gimana caranya jadi expert di MiniThreads?',
        tags: ['tutorial', 'expert']
      }
    }).then((res) => {
      expect(res.status).to.eq(201);
      postId = res.body.data.id;

      // Small wait to ensure DB consistency (optional but helpful in some environments)
      cy.wait(500);

      // 2. Edit 3 times
      for (let i = 1; i <= 3; i++) {
        cy.request({
          method: 'PUT',
          url: `${baseUrl}/posts/${postId}`,
          headers: { Authorization: `Bearer ${newbieToken}` },
          body: {
            category_id: categoryId,
            title: `Edit Judul Ke-${i}`,
            body: `Body edit ke-${i}`,
            tags: ['edited']
          }
        });
      }

      // 3. Edit 4th time (Must fail)
      cy.request({
        method: 'PUT',
        url: `${baseUrl}/posts/${postId}`,
        headers: { Authorization: `Bearer ${newbieToken}` },
        body: {
          category_id: categoryId,
          title: 'Edit Ilegal',
          body: 'Gagal gan jatah abis',
        },
        failOnStatusCode: false
      }).then((failRes) => {
        expect(failRes.status).to.eq(400);
        expect(failRes.body.message).to.contain('Slot edit habis');
      });
    });
  });

  /**
   * 5. COMMENTS & ACCEPTED ANSWER
   */
  it('05. Comment Logic: Create & Best Answer Rewards', () => {
    // 1. Admin comment on Newbie's post
    cy.request({
      method: 'POST',
      url: `${baseUrl}/posts/${postId}/comments`,
      headers: { Authorization: `Bearer ${adminToken}` },
      body: { body: 'Ini jawaban paling jos dari Admin.' }
    }).then((res) => {
      commentId = res.body.data.id;

      // 2. Newbie marks Admin's comment as accepted answer
      cy.request({
        method: 'POST',
        url: `${baseUrl}/posts/${postId}/comments/${commentId}/toggle-accepted`,
        headers: { Authorization: `Bearer ${newbieToken}` }
      }).then((acceptRes) => {
        expect(acceptRes.status).to.eq(200);
        expect(acceptRes.body.data.is_accepted).to.eq(true);
      });

      // 3. Verify Admin got +15 points
      cy.request({
        method: 'GET',
        url: `${baseUrl}/auth/me`,
        headers: { Authorization: `Bearer ${adminToken}` }
      }).then((adminRes) => {
        expect(adminRes.body.user.reputation_points).to.be.at.least(15);
      });
    });
  });

  /**
   * 6. SEARCH FEATURES
   */
  it('06. Search Features: Global & Scoped', () => {
    // Scoped search for newbie's post
    cy.request({
      method: 'GET',
      url: `${baseUrl}/search/posts`,
      qs: { keyword: 'Judul' }
    }).then((res) => {
      expect(res.status).to.eq(200);
      expect(res.body.data.data.length).to.be.at.least(1);
    });

    // Global search
    cy.request({
      method: 'GET',
      url: `${baseUrl}/search/global`,
      qs: { keyword: 'edited' }
    }).then((res) => {
      expect(res.status).to.eq(200);
      expect(res.body.data.posts.length).to.be.at.least(1);
    });
  });

  /**
   * 7. BOOKMARKS & NOTIFICATIONS
   */
  it('07. Social: Bookmarks & Profile', () => {
    // Toggle Bookmark
    cy.request({
      method: 'POST',
      url: `${baseUrl}/posts/${postId}/bookmark`,
      headers: { Authorization: `Bearer ${adminToken}` }
    }).then((res) => {
      expect(res.status).to.eq(200);
      expect(res.body.message).to.contain('berhasil');
    });

    // Update Profile
    cy.request({
      method: 'POST',
      url: `${baseUrl}/profile/update`,
      headers: { Authorization: `Bearer ${newbieToken}` },
      body: {
        bio: 'Saya newbie yang sudah punya 20 poin lebih, bro!'
      }
    }).then((res) => {
      expect(res.status).to.eq(200);
    });
  });

  /**
   * 8. CLEANUP: DELETE DATA (ONLY ADMIN/OWNER)
   */
  it('08. Cleanup: Delete Test Content', () => {
    // Delete Post (Owner)
    if (postId) {
      cy.request({
        method: 'DELETE',
        url: `${baseUrl}/posts/${postId}`,
        headers: { Authorization: `Bearer ${newbieToken}` },
        failOnStatusCode: false
      });
    }

    // Force Delete Category (Admin)
    if (categoryId) {
      cy.request({
        method: 'DELETE',
        url: `${baseUrl}/categories/${categoryId}`,
        headers: { Authorization: `Bearer ${adminToken}` },
        failOnStatusCode: false
      });
    }
  });
});
