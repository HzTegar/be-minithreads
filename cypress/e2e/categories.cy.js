describe('Modul Kategori', () => {
    const baseUrl = '/api/categories';
    let adminToken;
    let categoryId;

    before(() => {
        cy.log('Melakukan login sebagai Admin...');
        // Login sebagai Admin
        cy.request('POST', '/api/auth/login', {
            email: 'admin@minithreads.com',
            password: 'password123'
        }).then((response) => {
            adminToken = response.body.access_token;
            cy.log('Admin berhasil login.');
        });
    });

    it('Harus dapat menampilkan semua daftar kategori (Publik)', () => {
        cy.log('Mengambil semua daftar kategori...');
        cy.request('GET', baseUrl).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data).to.be.an('array');
            cy.log('Daftar kategori berhasil dimuat.');
        });
    });

    it('Harus berhasil membuat kategori baru (Khusus Admin)', () => {
        cy.log('Membuat kategori baru oleh Admin...');
        const namaKat = `Kategori ${Date.now()}`;
        cy.request({
            method: 'POST',
            url: baseUrl,
            headers: { Authorization: `Bearer ${adminToken}` },
            body: {
                name: namaKat,
                description: 'Deskripsi untuk testing kategori'
            }
        }).then((response) => {
            expect(response.status).to.eq(201);
            expect(response.body.data.name).to.eq(namaKat);
            categoryId = response.body.data.id;
            cy.log(`Kategori baru berhasil dibuat dengan ID: ${categoryId}`);
        });
    });

    it('Harus dapat menampilkan kategori tertentu', () => {
        cy.log(`Mengambil detail kategori ID: ${categoryId}`);
        cy.request('GET', `${baseUrl}/${categoryId}`).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.id).to.eq(categoryId);
            cy.log('Detail kategori ditemukan.');
        });
    });

    it('Harus berhasil memperbarui kategori (Khusus Admin)', () => {
        cy.log(`Memperbarui kategori ID: ${categoryId}`);
        const namaBaru = `Kat Diperbarui ${Date.now()}`;
        cy.request({
            method: 'PUT',
            url: `${baseUrl}/${categoryId}`,
            headers: { Authorization: `Bearer ${adminToken}` },
            body: {
                name: namaBaru
            }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.name).to.eq(namaBaru);
            cy.log('Kategori berhasil diperbarui.');
        });
    });

    it('Harus berhasil menghapus kategori (Khusus Admin)', () => {
        cy.log(`Menghapus kategori ID: ${categoryId}`);
        cy.request({
            method: 'DELETE',
            url: `${baseUrl}/${categoryId}`,
            headers: { Authorization: `Bearer ${adminToken}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.message).to.contain('berhasil');
            cy.log('Kategori berhasil dihapus.');
        });
    });
});
