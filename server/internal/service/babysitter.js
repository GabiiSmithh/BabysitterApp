import { Babysitter } from '../entity/babysitter.js';
import { v4 as uuidv4 } from 'uuid';

export class BabysitterService {
    constructor({ babysitterRepository }) {
        this.babysitterRepository = babysitterRepository;
    }

    async getByID(id) {
        return this.babysitterRepository.getByID(id);
    }

    async list() {
        return this.babysitterRepository.list();
    }

    async create(createBabysitterDTO) {
        const babysitter = new Babysitter({
            id: uuidv4(),
            birthDate: createBabysitterDTO.birthDate,
            experienceMonths: createBabysitterDTO.experienceMonths,
            gender: createBabysitterDTO.gender,
            cellphone: createBabysitterDTO.cellphone,
            rating: 0,
            name: createBabysitterDTO.name,
            email: createBabysitterDTO.email,
            password: createBabysitterDTO.password
        });

        babysitter.hashPassword();

        return this.babysitterRepository.create(babysitter);
    }

    async update(updateBabysitterDTO) {
        const foundBabysitter = await this.babysitterRepository.getByID(updateBabysitterDTO.id)
        
        if (!foundBabysitter) {
            return foundBabysitter
        }

        foundBabysitter.name = updateBabysitterDTO.name || foundBabysitter.name;
        foundBabysitter.email = updateBabysitterDTO.email || foundBabysitter.email;
        foundBabysitter.cellphone = updateBabysitterDTO.cellphone || foundBabysitter.cellphone;
        foundBabysitter.experience_months = updateBabysitterDTO.experience_months || foundBabysitter.experience_months;
        foundBabysitter.rating = updateBabysitterDTO.rating || foundBabysitter.rating;

        await this.babysitterRepository.update(foundBabysitter);

        return foundBabysitter;
    }
}