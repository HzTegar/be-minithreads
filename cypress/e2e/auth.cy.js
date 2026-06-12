describe('Modul Autentikasi', () => {
    const baseUrl = '/api/auth';
    const userBaru = {
        username: `pengguna_${Date.now()}`,
        email: `pengguna_${Date.now()}@example.com`,
        password: 'password123',
        password_confirmation: 'password123'
    };
    let token;

    it('Harus berhasil mendaftarkan pengguna baru', () => {
        cy.log('Mendaftarkan pengguna baru...');
        cy.request('POST', `${baseUrl}/register`, userBaru).then((response) => {
            expect(response.status).to.eq(201);
            expect(response.body.message).to.contain('berhasil');
            cy.log('Pendaftaran berhasil!');
        });
    });

    it('Harus berhasil login dan mengembalikan token', () => {
        cy.log('Melakukan login...');
        cy.request('POST', `${baseUrl}/login`, {
            email: userBaru.email,
            password: userBaru.password
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body).to.have.property('access_token');
            token = response.body.access_token;
            cy.log('Login berhasil, token didapatkan.');
        });
    });

    it('Harus dapat mengambil profil pengguna yang sedang login (me)', () => {
        cy.log('Mengambil data profil saya...');
        cy.request({
            method: 'GET',
            url: `${baseUrl}/me`,
            headers: { Authorization: `Bearer ${token}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.user.email).to.eq(userBaru.email);
            cy.log(`Profil ditemukan untuk email: ${response.body.user.email}`);
        });
    });

    it('Harus berhasil memperbarui profil pengguna', () => {
        cy.log('Memperbarui profil...');
        cy.request({
            method: 'POST',
            url: '/api/profile/update',
            headers: { Authorization: `Bearer ${token}` },
            body: {
                bio: 'Pembaruan bio dari Cypress testing',
                location: 'Kota Cypress'
            }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.user.bio).to.eq('Pembaruan bio dari Cypress testing');
            cy.log('Profil berhasil diperbarui.');
        });
    });

    it('Harus berhasil logout', () => {
        cy.log('Melakukan logout...');
        cy.request({
            method: 'POST',
            url: `${baseUrl}/logout`,
            headers: { Authorization: `Bearer ${token}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.message).to.contain(
                "Berhasil logout",
            );
            cy.log('Logout berhasil, sesi berakhir.');
        });
    });
});
