describe('Modul Postingan', () => {
    const baseUrl = '/api/posts';
    let userToken;
    let adminToken;
    let postId;
    let categoryId;

    before(() => {
        cy.log('Menyiapkan token akses untuk Admin dan User...');
        // Login sebagai Admin untuk mendapatkan kategori dan token untuk akses terbatas
        cy.request('POST', '/api/auth/login', {
            email: 'admin@minithreads.com',
            password: 'password123'
        }).then((response) => {
            adminToken = response.body.access_token;

            // Ambil ID Kategori yang valid
            return cy.request('GET', '/api/categories');
        }).then((catRes) => {
            categoryId = catRes.body.data[0].id;

            // Login sebagai User biasa
            return cy.request('POST', '/api/auth/login', {
                email: 'user@minithreads.com',
                password: 'password123'
            });
        }).then((response) => {
            userToken = response.body.access_token;
            cy.log('Token siap digunakan.');
        });
    });

    it('Harus mendapatkan poin yang cukup untuk posting (Interaksi)', () => {
        cy.log('Melakukan interaksi untuk menambah poin...');
        // Cari postingan yang sudah ada untuk berinteraksi
        cy.request('GET', baseUrl).then((res) => {
            const posts = res.body.data.data || res.body.data;
            if (posts.length > 0) {
                // Like (+10 poin biasanya)
                cy.request({
                    method: 'POST',
                    url: '/api/like',
                    headers: { Authorization: `Bearer ${userToken}` },
                    body: { target_id: posts[0].id, target_type: 'post' }
                });

                // Upvote (+5 poin biasanya)
                cy.request({
                    method: 'POST',
                    url: '/api/vote',
                    headers: { Authorization: `Bearer ${userToken}` },
                    body: { target_id: posts[0].id, target_type: 'post', vote_type: 'up' }
                });
                cy.log('Interaksi berhasil dikirim.');
            }
        });
    });

    it('Harus berhasil membuat postingan baru', () => {
        cy.log('Membuat postingan baru...');
        const dataPost = {
            title: 'Postingan Testing Cypress ' + Date.now(),
            body: 'Ini adalah isi konten postingan yang dibuat melalui Cypress.',
            category_id: categoryId,
            tags: ['cypress', 'testing']
        };

        cy.request({
            method: 'POST',
            url: baseUrl,
            headers: { Authorization: `Bearer ${userToken}` },
            body: dataPost
        }).then((response) => {
            expect(response.status).to.eq(201);
            expect(response.body.data.title).to.eq(dataPost.title);
            postId = response.body.data.id;
            cy.log(`Postingan berhasil dibuat dengan ID: ${postId}`);
        });
    });

    it('Harus dapat menampilkan daftar postingan dengan paginasi dan filter', () => {
        cy.log('Mengambil daftar postingan berdasarkan kategori...');
        cy.request('GET', `${baseUrl}?category_id=${categoryId}`).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.data).to.be.an('array');
            cy.log('Daftar postingan berhasil dimuat.');
        });
    });

    it('Harus dapat menampilkan detail postingan tertentu', () => {
        cy.log(`Mengambil detail postingan ID: ${postId}`);
        cy.request('GET', `${baseUrl}/${postId}`).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.id).to.eq(postId);
            cy.log('Detail postingan berhasil ditemukan.');
        });
    });

    it('Harus berhasil memperbarui postingan (dan melacak riwayat)', () => {
        cy.log(`Memperbarui postingan ID: ${postId}`);
        cy.request({
            method: 'PUT',
            url: `${baseUrl}/${postId}`,
            headers: { Authorization: `Bearer ${userToken}` },
            body: {
                category_id: categoryId,
                title: 'Judul Diperbarui oleh Cypress',
                body: 'Konten body yang sudah diperbarui.'
            }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.title).to.eq('Judul Diperbarui oleh Cypress');
            cy.log('Postingan berhasil diperbarui.');
        });
    });

    it('Harus dapat melihat riwayat edit postingan (Hanya Admin/Moderator)', () => {
        cy.log(`Melihat riwayat edit untuk postingan ID: ${postId}`);
        cy.request({
            method: 'GET',
            url: `${baseUrl}/${postId}/history`,
            headers: { Authorization: `Bearer ${adminToken}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data).to.be.an('array');
            expect(response.body.data.length).to.be.at.least(1);
            cy.log('Riwayat edit berhasil ditemukan.');
        });
    });

    it('Harus berhasil menghapus postingan', () => {
        cy.log(`Menghapus postingan ID: ${postId}`);
        cy.request({
            method: 'DELETE',
            url: `${baseUrl}/${postId}`,
            headers: { Authorization: `Bearer ${userToken}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.message).to.contain('berhasil');
            cy.log('Postingan berhasil dihapus.');
        });
    });
});
