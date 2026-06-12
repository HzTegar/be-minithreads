describe('Modul Notifikasi', () => {
    let userToken;
    let notifId;

    before(() => {
        cy.log('Melakukan login untuk mendapatkan token...');
        // Login sebagai User
        cy.request('POST', '/api/auth/login', {
            email: 'user@minithreads.com',
            password: 'password123'
        }).then((response) => {
            userToken = response.body.access_token;
            cy.log('Token berhasil didapatkan.');
        });
    });

    it('Harus dapat menampilkan daftar notifikasi', () => {
        cy.log('Mengambil daftar notifikasi...');
        cy.request({
            method: 'GET',
            url: '/api/notifications',
            headers: { Authorization: `Bearer ${userToken}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.data).to.be.an('array');
            if (response.body.data.data.length > 0) {
                notifId = response.body.data.data[0].id;
                cy.log(`Notifikasi ditemukan, ID notif: ${notifId}`);
            } else {
                cy.log('Belum ada notifikasi untuk user ini.');
            }
        });
    });

    it('Harus dapat menandai notifikasi sebagai terbaca', () => {
        if (notifId) {
            cy.log(`Menandai notifikasi ID: ${notifId} sebagai terbaca...`);
            cy.request({
                method: 'POST',
                url: `/api/notifications/${notifId}/read`,
                headers: { Authorization: `Bearer ${userToken}` }
            }).then((response) => {
                expect(response.status).to.eq(200);
                expect(response.body.message).to.contain('berhasil');
                cy.log('Notifikasi berhasil ditandai sebagai terbaca.');
            });
        } else {
            cy.log('Skip test: Tidak ada notifikasi untuk ditandai.');
        }
    });

    it('Harus dapat menandai semua notifikasi sebagai terbaca', () => {
        cy.log('Menandai semua notifikasi sebagai terbaca...');
        cy.request({
            method: 'POST',
            url: '/api/notifications/read-all',
            headers: { Authorization: `Bearer ${userToken}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.message).to.contain('berhasil');
            cy.log('Semua notifikasi berhasil ditandai sebagai terbaca.');
        });
    });

    it('Harus dapat menghapus notifikasi', () => {
        if (notifId) {
            cy.log(`Menghapus notifikasi ID: ${notifId}...`);
            cy.request({
                method: 'DELETE',
                url: `/api/notifications/${notifId}`,
                headers: { Authorization: `Bearer ${userToken}` }
            }).then((response) => {
                expect(response.status).to.eq(200);
                expect(response.body.message).to.contain('berhasil');
                cy.log('Notifikasi berhasil dihapus.');
            });
        } else {
            cy.log('Skip test: Tidak ada notifikasi untuk dihapus.');
        }
    });
});
