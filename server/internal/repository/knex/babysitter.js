import { Babysitter } from '../../entity/babysitter.js';

export class BabysitterRepository {
    constructor({ db }) {
        this.db = db;
    }

    async getByID(id) {
        const foundUsers = await this.db('user as u')
            .select('*')
            .join('babysitter as b', 'u.id', '=', 'b.user_id')
            .where('u.id', id);

        if (!foundUsers.length) {
            return null;
        }

        return new Babysitter({
            id: foundUsers[0].id,
            birthDate: foundUsers[0].birth_date,
            experienceMonths: foundUsers[0].experience_months,
            gender: foundUsers[0].gender,
            cellphone: foundUsers[0].cellphone,
            rating: foundUsers[0].rating,
            name: foundUsers[0].name,
            email: foundUsers[0].email,
            password: foundUsers[0].password
        });
    }

    async list() {
        const foundUsers = await this.db('user as u')
            .select('*')
            .join('babysitter as b', 'u.id', '=', 'b.user_id');

        return foundUsers.map(foundUser => new Babysitter({
            id: foundUser.id,
            birthDate: foundUser.birth_date,
            experienceMonths: foundUser.experience_months,
            gender: foundUser.gender,
            cellphone: foundUser.cellphone,
            rating: foundUser.rating,
            name: foundUser.name,
            email: foundUser.email,
            password: foundUser.password
        }));
    }

    async create(babysitter) {
        try {
            await this.db.transaction(async (trx) => {
                await trx('user').insert({
                    id: babysitter.id,
                    birth_date: babysitter.birthDate,
                    gender: babysitter.gender,
                    cellphone: babysitter.cellphone,
                    name: babysitter.name,
                    email: babysitter.email,
                    password: babysitter.password
                });

                await trx('babysitter').insert({
                    user_id: babysitter.id,
                    experience_months: babysitter.experienceMonths,
                    rating: babysitter.rating
                });
            });

            return babysitter;
        } catch (error) {
            if (error.code === 'ER_DUP_ENTRY') {
                throw new Error('Email already exists.');
            }
            throw error;
        }
    }

    async update(babysitter) {
        try {
            await this.db.transaction(async (trx) => {
                await trx('user').where('id', babysitter.id).update({
                    cellphone: babysitter.cellphone,
                    name: babysitter.name,
                    email: babysitter.email
                });

                await trx('babysitter').where('user_id', babysitter.id).update({
                    experience_months: babysitter.experienceMonths,
                    rating: babysitter.rating
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