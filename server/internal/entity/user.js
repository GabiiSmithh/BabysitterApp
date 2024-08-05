import bcrypt from 'bcrypt';

export class User {
    constructor({ 
        id,
        name,
        gender,
        email,
        password,
        cellphone,
        birthDate
    }) {
        this.id = id;
        this.name = name;
        this.gender = gender;
        this.email = email;
        this.password = password;
        this.cellphone = cellphone;
        this.birthDate = birthDate;
    }

    hashPassword() {
        this.password = bcrypt.hashSync(this.password, 10);
    }
}