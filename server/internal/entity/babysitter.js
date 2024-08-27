import { User } from './user.js';

export class Babysitter extends User {
    constructor({
        id,
        name,
        gender,
        email,
        password,
        cellphone,
        birthDate,
        roles,
        experienceMonths,
        rating
    }) {
        super({ id, name, gender, email, password, cellphone, birthDate, roles });
        this.experienceMonths = experienceMonths;
        this.rating = rating;
    }
}
