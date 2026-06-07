describe('MiniThreads API & Logic Features Test', () => {
  let userToken;
  let adminToken;
  let postId;
  let commentId;
  let categoryId;

  // Setup: Kita asumsikan database sudah di-seed atau kita buat data via API
  before(() => {
    // 1. Login sebagai User Biasa
    cy.request({
        method: 'POST',
        url: '/api/auth/login',
        body: { email: 'user@minithreads.com', password: 'password' },
        failOnStatusCode: false
    }).then((response) => {
        if (response.status === 200) {
            userToken = response.body.access_token;
        } else {
            cy.request('POST', '/api/auth/login', {
                email: 'user@minithreads.com',
                password: 'password123'
            }).then((altRes) => {
                userToken = altRes.body.access_token;
            });
        }
    });

    // 2. Login sebagai Admin
    cy.request({
        method: 'POST',
        url: '/api/auth/login',
        body: { email: 'admin@minithreads.com', password: 'password' },
        failOnStatusCode: false
    }).then((response) => {
        if (response.status === 200) {
            adminToken = response.body.access_token;
        } else {
            cy.request('POST', '/api/auth/login', {
                email: 'admin@minithreads.com',
                password: 'password123'
            }).then((altRes) => {
                adminToken = altRes.body.access_token;
            });
        }
    });

    // 3. Ambil Category ID valid
    cy.request('GET', '/api/categories').then((res) => {
        categoryId = res.body.data[0].id;

        // BIAR USER PUNYA POIN (MINIMAL 20)
        // Admin buat 2 post pancingan
        for (let i = 1; i <= 2; i++) {
          cy.request({
            method: 'POST',
            url: '/api/posts',
            headers: { Authorization: `Bearer ${adminToken}` },
            body: {
              category_id: categoryId,
              title: 'Pancingan Poin ' + i,
              body: 'Admin post'
            }
          }).then((p) => {
            cy.request({
              method: 'POST',
              url: '/api/like',
              headers: { Authorization: `Bearer ${userToken}` },
              body: { target_id: p.body.data.id, target_type: 'post' }
            });
          });
        }
    });
  });

  it('1. User memosting pertanyaan baru', () => {
    cy.request({
      method: 'POST',
      url: '/api/posts',
      headers: { Authorization: `Bearer ${userToken}` },
      body: {
        category_id: categoryId, 
        title: 'Bagaimana cara belajar Cypress dengan cepat?',
        body: 'Saya ingin belajar E2E testing untuk project Laravel saya.',
        tags: ['testing', 'cypress', 'javascript']
      }
    }).then((response) => {
      expect(response.status).to.eq(201);
      expect(response.body.success).to.be.true;
      postId = response.body.data.id;
    });
  });

  it('2. User lain (Admin) menjawab pertanyaan tersebut', () => {
    cy.request({
      method: 'POST',
      url: `/api/posts/${postId}/comments`,
      headers: { Authorization: `Bearer ${adminToken}` },
      body: {
        body: 'Kamu bisa mulai dengan membaca dokumentasi resmi Cypress, bro!'
      }
    }).then((response) => {
      expect(response.status).to.eq(201);
      commentId = response.body.data.id;
    });
  });

  it('3. User TIDAK BISA mengarsipkan post jika belum ada jawaban terbaik', () => {
    cy.request({
      method: 'POST',
      url: `/api/posts/${postId}/toggle-archive`,
      headers: { Authorization: `Bearer ${userToken}` },
      failOnStatusCode: false
    }).then((response) => {
      expect(response.status).to.eq(400);
      expect(response.body.message).to.contain('belum ada jawaban terbaik');
    });
  });

  it('4. User memilih jawaban terbaik', () => {
    cy.request({
      method: 'POST',
      url: `/api/posts/${postId}/comments/${commentId}/toggle-accepted`,
      headers: { Authorization: `Bearer ${userToken}` }
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.message).to.contain('Jawaban terbaik berhasil dipilih');
    });
  });

  it('5. User SEKARANG BISA mengarsipkan (close) post', () => {
    cy.request({
      method: 'POST',
      url: `/api/posts/${postId}/toggle-archive`,
      headers: { Authorization: `Bearer ${userToken}` }
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.message).to.contain('Postingan berhasil diarsipkan');
    });
  });

  it('6. Tidak bisa memberi komentar pada postingan yang sudah diarsipkan', () => {
    cy.request({
      method: 'POST',
      url: `/api/posts/${postId}/comments`,
      headers: { Authorization: `Bearer ${adminToken}` },
      body: { body: 'Test komen di post closed' },
      failOnStatusCode: false
    }).then((response) => {
      expect(response.status).to.eq(403);
      expect(response.body.message).to.contain('sudah diarsipkan/ditutup');
    });
  });

  it('7. User (Biasa) mencoba menghapus komentar (Harus Gagal)', () => {
    cy.request({
      method: 'DELETE',
      url: `/api/comments/${commentId}`,
      headers: { Authorization: `Bearer ${userToken}` },
      failOnStatusCode: false
    }).then((response) => {
      expect(response.status).to.eq(403);
      expect(response.body.message).to.contain('Hanya Admin yang bisa menghapus komentar');
    });
  });

  it('8. Admin menghapus komentar (Harus Berhasil)', () => {
    cy.request({
      method: 'DELETE',
      url: `/api/comments/${commentId}`,
      headers: { Authorization: `Bearer ${adminToken}` }
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.message).to.contain('berhasil dihapus secara permanen oleh Admin');
    });
  });
});
