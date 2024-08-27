import { Service } from '../../entity/service.js';

export class ServiceRepository {
    constructor({ db }) {
        this.db = db;
    }

    async getByID(id) {
        const foundServices = await this.db('service as s')
            .select('*')
            .where('s.id', id);

        if (!foundServices.length) {
            return null;
        }

        return new Service({
            id: foundServices[0].id,
            babysitterId: foundServices[0].babysitter_id,
            tutorId: foundServices[0].tutor_id,
            startDate: foundServices[0].start_date,
            endDate: foundServices[0].end_date,
            value: foundServices[0].value,
            childrenCount: foundServices[0].children_count,
            address: foundServices[0].address,
        });
    }

    async list() {
        const foundServices = await this.db('service as s')
            .select('*');

        return foundServices.map(foundService => new Service({
            id: foundService.id,
            babysitterId: foundService.babysitter_id,
            tutorId: foundService.tutor_id,
            startDate: foundService.start_date,
            endDate: foundService.end_date,
            value: foundService.value,
            childrenCount: foundService.children_count,
            address: foundService.address,
        }));
    }

    async listByTutorId(tutorId) {
        const foundServices = await this.db('service as s')
            .select('*')
            .where('s.tutor_id', tutorId);

        return foundServices.map(foundService => new Service({
            id: foundService.id,
            babysitterId: foundService.babysitter_id,
            tutorId: foundService.tutor_id,
            startDate: foundService.start_date,
            endDate: foundService.end_date,
            value: foundService.value,
            childrenCount: foundService.children_count,
            address: foundService.address,
        }));
    }

    async create(service) {
        try {
            await this.db('service').insert({
                id: service.id,
                babysitter_id: service.babysitterId,
                tutor_id: service.tutorId,
                start_date: service.startDate,
                end_date: service.endDate,
                value: service.value,
                children_count: service.childrenCount,
                address: service.address,
            });

            return service;
        } catch (error) {
            throw error;
        }
    }

    async update(service) {
        try {
            await this.db('service').where('id', service.id).update({
                babysitter_id: service.babysitterId,
                start_date: service.startDate,
                end_date: service.endDate,
                value: service.value,
                children_count: service.childrenCount,
                address: service.address,
            });

            return service;
        } catch (error) {
            throw error;
        }
    }
}