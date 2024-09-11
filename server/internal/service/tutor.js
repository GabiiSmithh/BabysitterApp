import { Tutor } from '../entity/tutor.js';
import { v4 as uuidv4 } from 'uuid';

export class TutorService {
    constructor({ tutorRepository, serviceRepository }) {
        this.tutorRepository = tutorRepository;
        this.serviceRepository = serviceRepository;
    }

    async getByID(id) {
        return this.tutorRepository.getByID(id);
    }

    async list() {
        return this.tutorRepository.list();
    }

    async listServices (tutorId) {
        return this.serviceRepository.listByTutorId(tutorId);
    }

    async create(createTutorDTO) {
        const tutor = new Tutor({
            id: uuidv4(),
            birthDate: createTutorDTO.birthDate,
            gender: createTutorDTO.gender,
            cellphone: createTutorDTO.cellphone,
            rating: 0,
            name: createTutorDTO.name,
            email: createTutorDTO.email,
            password: createTutorDTO.password,
            address: createTutorDTO.address,
            childrenCount: createTutorDTO.childrenCount,
        });

        tutor.hashPassword();

        return this.tutorRepository.create(tutor);
    }

    async update(updateTutorDTO) {
        const foundTutor = await this.tutorRepository.getByID(updateTutorDTO.id)
        
        if (!foundTutor) {
            return foundTutor
        }

        foundTutor.name = updateTutorDTO.name || foundTutor.name;
        foundTutor.email = updateTutorDTO.email || foundTutor.email;
        foundTutor.cellphone = updateTutorDTO.cellphone || foundTutor.cellphone;
        foundTutor.address = updateTutorDTO.address || foundTutor.address;
        foundTutor.childrenCount = updateTutorDTO.childrenCount || foundTutor.childrenCount;
        foundTutor.rating = updateTutorDTO.rating || foundTutor.rating;

        await this.tutorRepository.update(foundTutor);

        return foundTutor;
    }
}