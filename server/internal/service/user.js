export class UserService {
    constructor({ userRepository }) {
        this.userRepository = userRepository;
    }

    async getByEmail(email) {
        return this.userRepository.getByEmail(email);
    }
}