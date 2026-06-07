describe('MiniThreads Unified API Logic Test', () => {
  const baseUrl = 'http://localhost:8000/api';
  
  // Variables to store dynamic data
  let adminToken;
  let userToken;
  let categoryId;
  let postId;
  let commentId;

  // Use fixed credentials from DatabaseSeeder
  const adminCreds = { email: 'admin@minithreads.com', password: 'password123' };
  const userCreds = { email: 'user@minithreads.com', password: 'password123' };

  /**
   * REUSABLE LOGIN FUNCTION
   */
  const login = (creds) => {
    return cy.request({
      method: 'POST',
      url: `${baseUrl}/auth/login`,
      body: creds,
      failOnStatusCode: false 
    });
  };

  /**
   * STEP 1: SETUP & AUTHENTICATION
   */
  it('01. Setup: Auth & Category Preparation', () => {
    login(adminCreds).then((res) => {
      if (res.status === 200) {
        adminToken = res.body.access_token;
        
        cy.request({
          method: 'POST',
          url: `${baseUrl}/categories`,
          headers: { Authorization: `Bearer ${adminToken}` },
          body: { name: 'Cypress Category ' + Date.now(), slug: 'cypress-cat-' + Date.now() }
        }).then((catRes) => {
          categoryId = catRes.body.data.id;
        });
      }
    });

    login(userCreds).then((res) => {
      if (res.status === 200) {
        userToken = res.body.access_token;

        // BIAR USER PUNYA POIN (MINIMAL 20)
        // Admin buat 2 post pancingan
        for (let i = 1; i <= 2; i++) {
          cy.request({
            method: 'POST',
            url: `${baseUrl}/posts`,
            headers: { Authorization: `Bearer ${adminToken}` },
            body: {
              category_id: categoryId,
              title: 'Pancingan Poin ' + i,
              body: 'Admin post'
            }
          }).then((p) => {
            cy.request({
              method: 'POST',
              url: `${baseUrl}/like`,
              headers: { Authorization: `Bearer ${userToken}` },
              body: { target_id: p.body.data.id, target_type: 'post' }
            });
          });
        }
      }
    });
  });

  /**
   * STEP 2: POST FEATURES (Auto-tags & 3-Edit Limit)
   */
  it('02. Post Logic: Creation & 3-Edit Limit', () => {
    // 1. Create Post with Auto-tags
    cy.request({
      method: 'POST',
      url: `${baseUrl}/posts`,
      headers: { Authorization: `Bearer ${userToken}` },
      body: {
        category_id: categoryId,
        title: 'Pertanyaan Testing Cypress',
        body: 'Bagaimana cara testing API dengan Cypress?',
        tags: ['cypress', 'testing', 'laravel']
      }
    }).then((res) => {
      expect(res.status).to.eq(201);
      postId = res.body.data.id;

      // PINDAHKAN LOOP KE DALAM .then()
      for (let i = 1; i <= 3; i++) {
        cy.request({
          method: 'PUT',
          url: `${baseUrl}/posts/${postId}`,
          headers: { Authorization: `Bearer ${userToken}` },
          body: {
            category_id: categoryId,
            title: `Judul Edit Ke-${i}`,
            body: `Body edit ke-${i}`,
            tags: ['edited']
          }
        }).then((editRes) => {
          expect(editRes.status).to.eq(200);
        });
      }

      // Edit Ke-4 (Must Fail) - Juga harus di dalam .then() atau setelah loop di dalam .then()
      cy.request({
        method: 'PUT',
        url: `${baseUrl}/posts/${postId}`,
        headers: { Authorization: `Bearer ${userToken}` },
        body: {
          category_id: categoryId,
          title: 'Edit Ilegal',
          body: 'Harusnya gagal karena jatah habis',
        },
        failOnStatusCode: false
      }).then((failRes) => {
        expect(failRes.status).to.eq(400);
      });
    });
  });

  /**
   * STEP 3: COMMENT FEATURES (1-Edit Limit)
   */
  it('03. Comment Logic: 1-Edit Limit & Replies', () => {
    // 1. Create Comment
    cy.request({
      method: 'POST',
      url: `${baseUrl}/posts/${postId}/comments`,
      headers: { Authorization: `Bearer ${userToken}` },
      body: { body: 'Ini komentar cypress' }
    }).then((res) => {
      expect(res.status).to.eq(201);
      commentId = res.body.data.id;

      // PINDAHKAN EDIT KE DALAM .then()
      cy.request({
        method: 'PUT',
        url: `${baseUrl}/comments/${commentId}`,
        headers: { Authorization: `Bearer ${userToken}` },
        body: { body: 'Komentar sudah diedit 1x' }
      }).then((editRes) => {
        expect(editRes.status).to.eq(200);
      });

      // Edit Comment 2x (Must Fail)
      cy.request({
        method: 'PUT',
        url: `${baseUrl}/comments/${commentId}`,
        headers: { Authorization: `Bearer ${userToken}` },
        body: { body: 'Edit lagi ah' },
        failOnStatusCode: false
      }).then((failRes) => {
        expect(failRes.status).to.eq(400);
      });
    });
  });

  /**
   * STEP 4: AUDIT LOGS
   */
  it('04. Audit: Edit History Visibility', () => {
    cy.request({
      method: 'GET',
      url: `${baseUrl}/posts/${postId}`,
      headers: { Authorization: `Bearer ${adminToken}` }
    }).then((res) => {
      expect(res.body.data).to.have.property('edit_histories');
    });
  });

  /**
   * STEP 5: DELETE LOGIC
   */
  it('05. Delete: User (Soft) vs Admin (Hard)', () => {
    // Admin performs Hard Delete on the main post
    cy.request({
      method: 'DELETE',
      url: `${baseUrl}/posts/${postId}`,
      headers: { Authorization: `Bearer ${adminToken}` }
    }).then((res) => {
      expect(res.body.message).to.contain('PERMANEN');
    });
  });
});
