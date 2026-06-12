describe('Modul Tag', () => {
    const baseUrl = '/api/tags';
    let userToken;
    let adminToken;
    let tagId;

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
    });

    it('Harus dapat menampilkan semua daftar tag (Publik)', () => {
        cy.log('Mengambil daftar tag...');
        cy.request('GET', baseUrl).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data).to.be.an('array');
            cy.log('Daftar tag berhasil dimuat.');
        });
    });

    it('Harus berhasil membuat tag baru otomatis saat membuat postingan (User Biasa)', () => {
        cy.log('User biasa membuat postingan dengan tag baru...');
        const rawTagName = `Tag-Baru-${Date.now()}`;
        const expectedTagName = rawTagName.toLowerCase();
        
        // Ambil kategori dulu agar bisa posting
        cy.request('GET', '/api/categories').then((catRes) => {
            const categoryId = catRes.body.data[0].id;

            cy.request({
                method: 'POST',
                url: '/api/posts',
                headers: { Authorization: `Bearer ${userToken}` },
                body: {
                    category_id: categoryId,
                    title: 'Postingan dengan Tag Baru ' + Date.now(),
                    body: 'Isi postingan untuk mengetes pembuatan tag otomatis.',
                    tags: [rawTagName, 'laravel', 'cypress']
                }
            }).then((response) => {
                expect(response.status).to.eq(201);
                
                // Verifikasi tag ada di dalam response postingan
                const tagsInPost = response.body.data.tags;
                const createdTag = tagsInPost.find(t => t.name.toLowerCase() === expectedTagName);
                expect(createdTag, 'Tag harus ada di dalam response postingan').to.exist;
                tagId = createdTag.id;
                cy.log(`Tag "${expectedTagName}" berhasil dibuat dengan ID: ${tagId}`);
                
                // Verifikasi tag tersebut sekarang ada di daftar tag global (gunakan cache buster ?t=)
                cy.request('GET', `${baseUrl}?t=${Date.now()}`).then((tagListRes) => {
                    const foundTag = tagListRes.body.data.find(t => 
                        t.name.toLowerCase() === expectedTagName || 
                        t.id === tagId
                    );
                    
                    if (!foundTag) {
                        cy.log('Daftar tag yang diterima (Cache Busted):', JSON.stringify(tagListRes.body.data));
                    }
                    
                    expect(foundTag, `Tag "${expectedTagName}" harus ada di daftar tag global`).to.exist;
                });
            });
        });
    });

    it('Harus dapat menampilkan detail tag tertentu', () => {
        if (!tagId) {
            cy.log('Skip: tagId tidak ditemukan dari test sebelumnya.');
            return;
        }
        cy.log(`Mengambil detail tag ID: ${tagId}`);
        cy.request('GET', `${baseUrl}/${tagId}`).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.id).to.eq(tagId);
            cy.log('Detail tag berhasil ditemukan.');
        });
    });

    it('Harus berhasil memperbarui nama tag (Khusus Admin)', () => {
        if (!tagId) {
            cy.log('Skip: tagId tidak ditemukan.');
            return;
        }
        cy.log(`Admin memperbarui tag ID: ${tagId}`);
        const namaBaru = `tag-diubah-${Date.now()}`;
        cy.request({
            method: 'PUT',
            url: `${baseUrl}/${tagId}`,
            headers: { Authorization: `Bearer ${adminToken}` },
            body: {
                name: namaBaru
            }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.data.name).to.eq(namaBaru);
            cy.log('Tag berhasil diperbarui oleh Admin.');
        });
    });

    it('Harus berhasil menghapus tag (Khusus Admin)', () => {
        if (!tagId) {
            cy.log('Skip: tagId tidak ditemukan.');
            return;
        }
        cy.log(`Admin menghapus tag ID: ${tagId}`);
        cy.request({
            method: 'DELETE',
            url: `${baseUrl}/${tagId}`,
            headers: { Authorization: `Bearer ${adminToken}` }
        }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body.message).to.contain('berhasil');
            cy.log('Tag berhasil dihapus oleh Admin.');
        });
    });
});
