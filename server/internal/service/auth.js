import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

export class AuthService {
    constructor({ secretKey, expiresIn }) {
        this.secretKey = secretKey;
        this.expiresIn = expiresIn;
    }

    async validateUserCredentials(user, password) {
        return await bcrypt.compare(password, user.password);
    }

    generateToken(user) {
        const payload = {
            user_id: user.id,
            email: user.email
        };
        
        const options = {
            expiresIn: this.expiresIn
        };

        return jwt.sign(payload, this.secretKey, options);
    }

    decodeToken(token) {
        return new Promise((resolve, reject) => {
            jwt.verify(token, this.secretKey, (err, decodedToken) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(decodedToken);
                }
            });
        });
    }
}