import { User } from './user.js';

export class Tutor extends User {
    constructor({
        id,
        name,
        gender,
        email,
        password,
        cellphone,
        birthDate,
        roles,
        address,
        childrenCount,
        rating
    }) {
        super({ id, name, gender, email, password, cellphone, birthDate, roles });
        this.address = address;
        this.childrenCount = childrenCount;
        this.rating = rating;
    }
}
