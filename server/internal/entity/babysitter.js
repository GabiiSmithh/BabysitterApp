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
        experienceMonths,
        rating
    }) {
        super({ id, name, gender, email, password, cellphone, birthDate });
        this.experienceMonths = experienceMonths;
        this.rating = rating;
    }
}
