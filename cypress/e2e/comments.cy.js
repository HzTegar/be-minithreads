describe('Modul Komentar', () => {
    let userToken;
    let adminToken;
    let postId;
    let commentId;
    let categoryId;

    before(() => {
        cy.log('Menyiapkan data awal untuk pengujian komentar...');
        // Login sebagai Admin untuk membuat postingan (melewati batas reputasi)
        cy.request('POST', '/api/auth/login', {
            email: 'admin@minithreads.com',
            password: 'password123'
        }).then((response) => {
            adminToken = response.body.access_token;

            // Ambil ID Kategori yang valid
            return cy.request('GET', '/api/categories').then((catRes) => {
                categoryId = catRes.body.data[0].id;

                // Buat postingan sebagai Admin
                return cy.request({
                    method: 'POST',
                    url: '/api/posts',
                    headers: { Authorization: `Bearer ${adminToken}` },
                    body: {
                        title: 'Postingan untuk Testing Komentar ' + Date.now(),
                        body: 'Isi postingan...',
                        category_id: categoryId
                    }
                });
            });
        }).then((postRes) => {
            postId = postRes.body.data.id;
            cy.log(`Postingan berhasil dibuat dengan ID: ${postId}`);

            // Sekarang login sebagai User biasa untuk memberikan komentar
            return cy.request('POST', '/api/auth/login', {
                email: 'user@minithreads.com',
                password: 'password123'
            });
        }).then((userRes) => {
            userToken = userRes.body.access_token;
            cy.log('Token User biasa siap digunakan.');
        });
    });

    it('Harus berhasil membuat komentar pada sebuah postingan', () => {
        cy.log(`Membuat komentar pada postingan ID: ${postId}`);
        cy.request({
            method: 'POST',
            url: `/api/posts/${postId}/comments`,
            headers: { Authorization: `Bearer ${userToken}` },
            body: {
                body: 'Ini adalah komentar pengujian dari Cypress.'
            }
        }).then((response) => {
            expect(response.status).to.eq(201);
            expect(response.body.data.body).to.eq('Ini adalah komentar pengujian dari Cypress.');
            commentId = response.body.data.id;
            cy.log(`Komentar berhasil dibuat dengan ID: ${commentId}`);
        });
    });

    it('Harus berhasil memperbarui komentar', () => {
        cy.log(`Memperbarui komentar ID: ${commentId}`);
        cy.request({
            method: 'PUT',
            url: `/api/comments/${commentId}`,
            headers: { Authorization: `Bearer ${userToken}` },
            body: {
                body: 'Isi komentar yang sudah diperbarui oleh Cypress.'
            }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.body).to.eq('Isi komentar yang sudah diperbarui oleh Cypress.');
            cy.log('Komentar berhasil diperbarui.');
        });
    });

    it('Harus dapat melihat riwayat edit komentar (Hanya Admin/Moderator)', () => {
        cy.log(`Melihat riwayat edit untuk komentar ID: ${commentId}`);
        cy.request({
            method: 'GET',
            url: `/api/comments/${commentId}/history`,
            headers: { Authorization: `Bearer ${adminToken}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data).to.be.an('array');
            cy.log('Riwayat edit komentar berhasil dimuat.');
        });
    });

    it('Harus dapat melakukan toggle like pada komentar', () => {
        cy.log(`Melakukan like/unlike pada komentar ID: ${commentId}`);
        cy.request({
            method: 'POST',
            url: `/api/comments/${commentId}/like`,
            headers: { Authorization: `Bearer ${userToken}` }
        }).then((response) => {
            // Bisa 201 untuk like pertama atau 200 untuk unlike
            expect([200, 201]).to.include(response.status);
            expect(response.body.message).to.contain('berhasil');
            cy.log('Toggle like pada komentar berhasil.');
        });
    });

    it('Harus dapat melakukan toggle status jawaban diterima (Hanya Pemilik Postingan)', () => {
        cy.log(`Menandai komentar ID: ${commentId} sebagai jawaban diterima pada postingan ID: ${postId}`);
        // Admin adalah pemilik postingan dalam setup ini
        cy.request({
            method: 'POST',
            url: `/api/posts/${postId}/comments/${commentId}/toggle-accepted`,
            headers: { Authorization: `Bearer ${adminToken}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.message).to.contain('berhasil');
            cy.log('Status jawaban diterima berhasil diubah.');
        });
    });

    it('Harus berhasil menghapus komentar (Hanya Admin)', () => {
        cy.log(`Menghapus komentar ID: ${commentId}`);
        cy.request({
            method: 'DELETE',
            url: `/api/comments/${commentId}`,
            headers: { Authorization: `Bearer ${adminToken}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.message).to.contain('berhasil');
            cy.log('Komentar berhasil dihapus oleh Admin.');
        });
    });
});
