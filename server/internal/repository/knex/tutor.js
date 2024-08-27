import { Tutor } from '../../entity/tutor.js';

export class TutorRepository {
    constructor({ db }) {
        this.db = db;
    }

    async getByID(id) {
        const foundUsers = await this.db('user as u')
            .select('*')
            .join('tutor as t', 'u.id', '=', 't.user_id')
            .where('u.id', id);

        if (!foundUsers.length) {
            return null;
        }

        return new Tutor({
            id: foundUsers[0].id,
            birthDate: foundUsers[0].birth_date,
            gender: foundUsers[0].gender,
            cellphone: foundUsers[0].cellphone,
            name: foundUsers[0].name,
            email: foundUsers[0].email,
            password: foundUsers[0].password,
            childrenCount: foundUsers[0].children_count,
            address: foundUsers[0].address,
            rating: foundUsers[0].rating
        });
    }

    async list() {
        const foundUsers = await this.db('user as u')
            .select('*')
            .join('tutor as t', 'u.id', '=', 't.user_id');

        return foundUsers.map(foundUser => new Tutor({
            id: foundUser.id,
            birthDate: foundUser.birth_date,
            gender: foundUser.gender,
            cellphone: foundUser.cellphone,
            name: foundUser.name,
            email: foundUser.email,
            password: foundUser.password,
            childrenCount: foundUser.children_count,
            address: foundUser.address,
            rating: foundUser.rating
        }));
    }

    async create(tutor) {
        try {
            await this.db.transaction(async (trx) => {
                await trx('user').insert({
                    id: tutor.id,
                    birth_date: tutor.birthDate,
                    gender: tutor.gender,
                    cellphone: tutor.cellphone,
                    name: tutor.name,
                    email: tutor.email,
                    password: tutor.password
                });

                await trx('tutor').insert({
                    user_id: tutor.id,
                    children_count: tutor.childrenCount,
                    address: tutor.address,
                    rating: tutor.rating,
                });
            });

            await trx('user_has_roles').insert({
                user_id: babysitter.id,
                role_name: 'tutor'
            });

            return tutor;
        } catch (error) {
            if (error.code === 'ER_DUP_ENTRY') {
                throw new Error('Email already exists.');
            }
            throw error;
        }
    }

    async update(tutor) {
        try {
            await this.db.transaction(async (trx) => {
                await trx('user').where('id', tutor.id).update({
                    cellphone: tutor.cellphone,
                    name: tutor.name,
                    email: tutor.email
                });

                await trx('tutor').where('user_id', tutor.id).update({
                    children_count: tutor.childrenCount,
                    address: tutor.address,
                    rating: tutor.rating
                });
            })
        } catch (error) {
            if (error.code === 'ER_DUP_ENTRY') {
                throw new Error('Email already exists.');
            }
            throw error;
        }
    }
}