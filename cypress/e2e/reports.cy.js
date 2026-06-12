describe('Modul Laporan (Report)', () => {
    let userToken;
    let adminToken;
    let reportId;
    let postId;

    before(() => {
        cy.log('Menyiapkan token untuk User dan Admin...');
        // Login sebagai Admin
        cy.request('POST', '/api/auth/login', {
            email: 'admin@minithreads.com',
            password: 'password123'
        }).then((response) => {
            adminToken = response.body.access_token;
        });

        // Login sebagai User
        cy.request('POST', '/api/auth/login', {
            email: 'user@minithreads.com',
            password: 'password123'
        }).then((response) => {
            userToken = response.body.access_token;
        });

        // Dapatkan satu postingan untuk dilaporkan
        cy.request('GET', '/api/posts').then((res) => {
            postId = res.body.data.data[0].id;
            cy.log(`Menyiapkan ID Postingan untuk dilaporkan: ${postId}`);
        });
    });

    it('Harus berhasil mengirim laporan baru (User)', () => {
        cy.log('Mengirim laporan...');
        cy.request({
            method: 'POST',
            url: '/api/reports',
            headers: { Authorization: `Bearer ${userToken}` },
            body: {
                target_id: postId,
                target_type: 'post',
                reason: 'Konten mengandung spam atau informasi palsu.',
                description: 'Laporan dikirim melalui testing Cypress.'
            }
        }).then((response) => {
            expect(response.status).to.eq(201);
            expect(response.body.message).to.contain('berhasil');
            cy.log('Laporan berhasil dikirim.');
        });
    });

    it('Harus dapat melihat daftar laporan (Admin)', () => {
        cy.log('Admin mengecek daftar laporan...');
        cy.request({
            method: 'GET',
            url: '/api/admin/reports',
            headers: { Authorization: `Bearer ${adminToken}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.data).to.be.an('array');
            reportId = response.body.data.data[0].id;
            cy.log(`Laporan ditemukan, ID laporan terbaru: ${reportId}`);
        });
    });

    it('Harus dapat melihat detail laporan tertentu (Admin)', () => {
        cy.log(`Admin melihat detail laporan ID: ${reportId}`);
        cy.request({
            method: 'GET',
            url: `/api/admin/reports/${reportId}`,
            headers: { Authorization: `Bearer ${adminToken}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.id).to.eq(reportId);
            cy.log('Detail laporan berhasil dimuat.');
        });
    });

    it('Harus dapat memperbarui status laporan (Admin)', () => {
        cy.log(`Admin memproses laporan ID: ${reportId}`);
        cy.request({
            method: 'PUT',
            url: `/api/admin/reports/${reportId}`,
            headers: { Authorization: `Bearer ${adminToken}` },
            body: {
                status: 'resolved'
            }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.status).to.eq('resolved');
            cy.log('Status laporan berhasil diperbarui menjadi resolved.');
        });
    });
});
