export class UserService {
    constructor({ userRepository }) {
        this.userRepository = userRepository;
    }

    async getByEmail(email) {
        return this.userRepository.getByEmail(email);
    }

    async assignBabysitter(assignBabysitterDTO){
        assignBabysitterDTO.rating = 0;
        return this.userRepository.assignBabysitter(assignBabysitterDTO);
    }

    async assignTutor(assignTutorDTO){
        assignTutorDTO.rating = 0;
        return this.userRepository.assignTutor(assignTutorDTO);
    }
}