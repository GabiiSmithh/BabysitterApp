import { Service } from '../../entity/service.js';

export class ServiceRepository {
    constructor({ db }) {
        this.db = db;
    }

    async getByID(id) {
        const foundServices = await this.db('service as s')
            .select('s.*', 'tutor.name as tutor_name', 'babysitter.name as babysitter_name')
            .join('user as tutor', 's.tutor_id', 'tutor.id')
            .leftJoin('user as babysitter', 's.babysitter_id', 'babysitter.id')
            .where('s.id', id);

        if (!foundServices.length) {
            return null;
        }

        return new Service({
            id: foundServices[0].id,
            babysitterId: foundServices[0].babysitter_id,
            babysitterName: foundServices[0].babysitter_name,
            tutorId: foundServices[0].tutor_id,
            tutorName: foundServices[0].tutor_name,
            startDate: foundServices[0].start_date,
            endDate: foundServices[0].end_date,
            value: foundServices[0].value,
            childrenCount: foundServices[0].children_count,
            address: foundServices[0].address,
        });
    }

    async list() {
        const foundServices = await this.db('service as s')
            .select('s.*', 'tutor.name as tutor_name')
            .join('user as tutor', 's.tutor_id', 'tutor.id')
            .whereNull('s.babysitter_id');

        return foundServices.map(foundService => new Service({
            id: foundService.id,
            tutorId: foundService.tutor_id,
            tutorName: foundService.tutor_name,
            startDate: foundService.start_date,
            endDate: foundService.end_date,
            value: foundService.value,
            childrenCount: foundService.children_count,
            address: foundService.address,
        }));
    }

    async listByTutorId(tutorId) {
        const foundServices = await this.db('service as s')
            .select('s.*', 'tutor.name as tutor_name', 'babysitter.name as babysitter_name')
            .join('user as tutor', 's.tutor_id', 'tutor.id')
            .leftJoin('user as babysitter', 's.babysitter_id', 'babysitter.id')
            .where('s.tutor_id', tutorId);

        return foundServices.map(foundService => new Service({
            id: foundService.id,
            babysitterId: foundService.babysitter_id,
            babysitterName: foundService.babysitter_name,
            tutorId: foundService.tutor_id,
            tutorName: foundService.tutor_name,
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