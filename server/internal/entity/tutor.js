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
        address,
        childrenCount,
        rating
    }) {
        super({ id, name, gender, email, password, cellphone, birthDate });
        this.address = address;
        this.childrenCount = childrenCount;
        this.rating = rating;
    }
}
