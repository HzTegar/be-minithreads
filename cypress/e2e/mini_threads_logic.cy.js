describe('MiniThreads API Logic Unified Test', () => {
  const baseUrl = 'http://localhost:8000/api';
  let userToken;
  let adminToken;
  let categoryId;
  let postId;
  let commentId;

  // Setup: Login and Category creation
 before(() => {
     // 1. Admin Login
     cy.request("POST", `${baseUrl}/auth/login`, {
         email: "admin@minithreads.com",
         password: "password123", // <--- UBAH DI SINI, TAMBAHKAN KATA '123'
     }).then((response) => {
         adminToken = response.body.access_token;

         // 2. Create Category for testing
         cy.request({
           method: 'POST',
           url: `${baseUrl}/categories`,
           headers: { Authorization: `Bearer ${adminToken}` },
           body: { 
             name: 'Cypress Testing ' + Date.now(), 
             slug: 'cypress-test-' + Date.now() 
           }
         }).then((catResponse) => {
           categoryId = catResponse.body.data.id;
         });
     });

     // 3. User Login
     cy.request("POST", `${baseUrl}/auth/login`, {
         email: "user@minithreads.com", // Pastikan email ini ada di seeder/DB
         password: "password123",
     }).then((response) => {
         userToken = response.body.access_token;

         // 4. BIAR USER PUNYA POIN (MINIMAL 20) UNTUK POSTING
         // Admin buat 2 post pancingan
         for (let i = 1; i <= 2; i++) {
             cy.request({
                 method: 'POST',
                 url: `${baseUrl}/posts`,
                 headers: { Authorization: `Bearer ${adminToken}` },
                 body: {
                     category_id: categoryId,
                     title: 'Post Pancingan ' + i,
                     body: 'Admin buat post untuk di-like user'
                 }
             }).then((pRes) => {
                 // User Like post admin (+10 poin x 2 = 20 poin)
                 cy.request({
                     method: 'POST',
                     url: `${baseUrl}/like`,
                     headers: { Authorization: `Bearer ${userToken}` },
                     body: { target_id: pRes.body.data.id, target_type: 'post' }
                 });
             });
         }
     });
 });

  context('Post Features', () => {
    it('Should allow User to create post with auto-tagging', () => {
      cy.request({
        method: 'POST',
        url: `${baseUrl}/posts`,
        headers: { Authorization: `Bearer ${userToken}` },
        body: {
          category_id: categoryId,
          title: 'Postingan Testing Cypress',
          body: 'Isi postingan testing cypress yang keren',
          tags: ['cypress', 'testing', 'laravel'] // Tag otomatis dibuat jika belum ada
        }
      }).then((response) => {
        expect(response.status).to.eq(201);
        expect(response.body.message).to.contain('berhasil diterbitkan');
        postId = response.body.data.id;
      });
    });

    it('Should enforce 3-edit limit for Posts', () => {
      // Edit 1, 2, 3
      for (let i = 1; i <= 3; i++) {
        cy.request({
          method: 'PUT',
          url: `${baseUrl}/posts/${postId}`,
          headers: { Authorization: `Bearer ${userToken}` },
          body: {
            category_id: categoryId,
            title: `Edit Post Ke-${i}`,
            body: `Isi edit ke-${i}`,
            tags: ['updated']
          }
        }).then((response) => {
          expect(response.status).to.eq(200);
        });
      }

      // Edit 4 (Should Fail)
      cy.request({
        method: 'PUT',
        url: `${baseUrl}/posts/${postId}`,
        headers: { Authorization: `Bearer ${userToken}` },
        body: {
          category_id: categoryId,
          title: 'Edit Post Ke-4',
          body: 'Ini harusnya gagal',
        },
        failOnStatusCode: false
      }).then((response) => {
        expect(response.status).to.eq(400);
        expect(response.body.message).to.contain('Slot edit habis');
      });
    });
  });

  context('Comment Features', () => {
    it('Should allow User to comment and reply', () => {
      // Create main comment
      cy.request({
        method: 'POST',
        url: `${baseUrl}/posts/${postId}/comments`,
        headers: { Authorization: `Bearer ${userToken}` },
        body: { body: 'Komentar utama cypress' }
      }).then((response) => {
        commentId = response.body.data.id;
        
        // Create reply
        cy.request({
          method: 'POST',
          url: `${baseUrl}/posts/${postId}/comments`,
          headers: { Authorization: `Bearer ${userToken}` },
          body: { body: 'Balasan cypress', parent_id: commentId }
        }).then((replyResponse) => {
          expect(replyResponse.status).to.eq(201);
        });
      });
    });

    it('Should enforce 1-edit limit for Comments', () => {
      // Edit 1 (Success)
      cy.request({
        method: 'PUT',
        url: `${baseUrl}/comments/${commentId}`,
        headers: { Authorization: `Bearer ${userToken}` },
        body: { body: 'Komentar yang sudah diedit' }
      }).then((response) => {
        expect(response.status).to.eq(200);
        expect(response.body.data.status).to.eq('edited');
      });

      // Edit 2 (Fail)
      cy.request({
        method: 'PUT',
        url: `${baseUrl}/comments/${commentId}`,
        headers: { Authorization: `Bearer ${userToken}` },
        body: { body: 'Edit lagi ah' },
        failOnStatusCode: false
      }).then((response) => {
        expect(response.status).to.eq(400);
        expect(response.body.message).to.contain('Slot edit habis');
      });
    });
  });

  context('Admin Audit & Delete Features', () => {
    it('Should show Edit History only to Admin', () => {
      // 1. Check as User (Should NOT have editHistories)
      cy.request({
        method: 'GET',
        url: `${baseUrl}/posts/${postId}`,
        headers: { Authorization: `Bearer ${userToken}` }
      }).then((response) => {
        expect(response.body.data).to.not.have.property('edit_histories');
      });

      // 2. Check as Admin (Should have editHistories)
      cy.request({
        method: 'GET',
        url: `${baseUrl}/posts/${postId}`,
        headers: { Authorization: `Bearer ${adminToken}` }
      }).then((response) => {
        expect(response.body.data).to.have.property('edit_histories');
        expect(response.body.data.edit_histories).to.be.an('array').with.lengthOf(3);
      });
    });

    it('Should show User only performs Soft Delete', () => {
        // Create a temporary post to delete
        cy.request({
          method: 'POST',
          url: `${baseUrl}/posts`,
          headers: { Authorization: `Bearer ${userToken}` },
          body: { category_id: categoryId, title: 'Post Mau Dihapus', body: 'Body' }
        }).then((response) => {
          const tempPostId = response.body.data.id;
          
          // Delete as User
          cy.request({
            method: 'DELETE',
            url: `${baseUrl}/posts/${tempPostId}`,
            headers: { Authorization: `Bearer ${userToken}` }
          }).then((delResponse) => {
            expect(delResponse.body.message).to.contain('Soft Delete');
          });
        });
      });

    it('Should allow Admin to perform Hard Delete', () => {
      cy.request({
        method: 'DELETE',
        url: `${baseUrl}/posts/${postId}`,
        headers: { Authorization: `Bearer ${adminToken}` }
      }).then((response) => {
        expect(response.body.message).to.contain('PERMANEN');
      });
    });
  });
});
