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
}