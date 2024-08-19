import { Service } from '../entity/service.js';
import { v4 as uuidv4 } from 'uuid';

export class ServiceService {
    constructor({ serviceRepository }) {
        this.serviceRepository = serviceRepository;
    }

    async getByID(id) {
        return this.serviceRepository.getByID(id);
    }

    async list() {
        return this.serviceRepository.list();
    }

    async create(createServiceDTO) {
        const service = new Service({
            id: uuidv4(),
            babysitterId: null,
            tutorId: createServiceDTO.tutorId,
            startDate: createServiceDTO.startDate,
            endDate: createServiceDTO.endDate,
            value: createServiceDTO.value,
            childrenCount: createServiceDTO.childrenCount,
            address: createServiceDTO.address,
        });

        return this.serviceRepository.create(service);
    }

    async update(updateServiceDTO) {
        const foundService = await this.serviceRepository.getByID(updateServiceDTO.id)
        
        if (!foundService) {
            return foundService
        }

        // TODO: validate if babysitter accepted a service, if so, return error before update data

        foundService.startDate = updateServiceDTO.startDate || foundService.startDate;
        foundService.endDate = updateServiceDTO.endDate || foundService.endDate;
        foundService.value = updateServiceDTO.value || foundService.value;
        foundService.childrenCount = updateServiceDTO.childrenCount || foundService.childrenCount;
        foundService.address = updateServiceDTO.address || foundService.address;

        await this.serviceRepository.update(foundService);

        return foundService;
    }
}