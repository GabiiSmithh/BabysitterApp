import { User } from '../../entity/user.js';

export class UserRepository {
    constructor({ db }) {
        this.db = db;
    }

    async getByEmail(email) {
        const foundUsers = await this.db('user as u')
            .select('*')
            .where('u.email', email);

        if (!foundUsers.length) {
            return null;
        }

        const userRoles = await this.db('user_has_roles as ur')
            .select('r.name')
            .leftJoin('role as r', 'ur.role_name', 'r.name')
            .where('ur.user_id', foundUsers[0].id);

        return new User({
            id: foundUsers[0].id,
            birthDate: foundUsers[0].birth_date,
            gender: foundUsers[0].gender,
            cellphone: foundUsers[0].cellphone,
            name: foundUsers[0].name,
            email: foundUsers[0].email,
            password: foundUsers[0].password,
            roles: userRoles.map(role => role.name),
        });
    }

    async getById(id) {
        const foundUsers = await this.db('user as u')
            .select('*')
            .where('u.id', id);

        if (!foundUsers.length) {
            return null;
        }

        const userRoles = await this.db('user_has_roles as ur')
            .select('r.name')
            .leftJoin('role as r', 'ur.role_name', 'r.name')
            .where('ur.user_id', foundUsers[0].id);

        return new User({
            id: foundUsers[0].id,
            birthDate: foundUsers[0].birth_date,
            gender: foundUsers[0].gender,
            cellphone: foundUsers[0].cellphone,
            name: foundUsers[0].name,
            email: foundUsers[0].email,
            password: foundUsers[0].password,
            roles: userRoles.map(role => role.name),
        });
    }

    async assignBabysitter(assignBabysitterDTO) {
        try {
            await this.db.transaction(async (trx) => {
                await trx('babysitter').insert({
                    user_id: assignBabysitterDTO.userId,
                    experience_months: assignBabysitterDTO.experienceMonths,
                    rating: assignBabysitterDTO.rating
                });

                await trx('user_has_roles').insert({
                    user_id: assignBabysitterDTO.userId,
                    role_name: 'babysitter'
                });
            });
        } catch (error) {
            throw error;
        }
    }

    async assignTutor(assignTutorDTO) {
        try {
            await this.db.transaction(async (trx) => {
                await trx('tutor').insert({
                    user_id: assignTutorDTO.userId,
                    address: assignTutorDTO.address,
                    children_count: assignTutorDTO.childrenCount,
                    rating: assignTutorDTO.rating
                });

                await trx('user_has_roles').insert({
                    user_id: assignTutorDTO.userId,
                    role_name: 'tutor'
                });
            });
        } catch (error) {
            throw error;
        }
    }

    async update(user) {
        try {
            await this.db('user').where('id', user.id).update({
                birth_date: user.birthDate,
                gender: user.gender,   
                cellphone: user.cellphone,
                name: user.name,
                email: user.email,
                password: user.password,
            });

            return user;
        } catch (error) {
            throw error;
        }
    }
}