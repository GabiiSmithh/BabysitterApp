export class ExpressServiceHandler {
    constructor({ serviceService }) {
        this.serviceService = serviceService;
    }

    async getByID(req, res) {
        try {
            const service = await this.serviceService.getByID(req.params.service_id);

            if (!service) {
                return res.status(404).json({ message: 'Service not found.' });
            }

            return res.status(200).json(service);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }

    async list(_, res) {
        try {
            const services = await this.serviceService.list();

            return res.status(200).json(services);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }

    async create(req, res) {
        try {
            const createServiceDTO = {
                tutorId: req.body.tutor_id,
                startDate: req.body.start_date,
                endDate: req.body.end_date,
                value: req.body.value,
                childrenCount: req.body.children_count,
                address: req.body.address,
            };

            const createdService = await this.serviceService.create(createServiceDTO);

            return res.status(201).json(createdService);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }

    async enrollBabysitter(req, res) {
        try {
            const enrollBabysitterDTO = {
                serviceId: req.params.service_id,
                babysitterId: req.user.id,
            };

            const enrolledService = await this.serviceService.enrollBabysitter(enrollBabysitterDTO);

            if (!enrolledService) {
                return res.status(404).json({ message: 'Service not found.' });
            }

            return res.status(200).json(enrolledService);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }

    async chooseEnrollment(req, res) {
        try {
            const { babysitter_id } = req.body;

            const chooseEnrollmentDTO = {
                serviceId: req.params.service_id,
                tutorId: req.user.id,
                babysitterId: babysitter_id,
            };

            const chosenService = await this.serviceService.chooseEnrollment(chooseEnrollmentDTO);

            if (!chosenService) {
                return res.status(404).json({ message: 'Service not found.' });
            }

            return res.status(200).json(chosenService);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }

    async update(req, res) {
        try {
            const updateServiceDTO = {
                id: req.params.service_id,
                startDate: req.body.start_date,
                endDate: req.body.end_date,
                value: req.body.value,
                childrenCount: req.body.children_count,
                address: req.body.address,
            };

            const updatedService = await this.serviceService.update(updateServiceDTO);

            if (!updatedService) {
                return res.status(404).json({ message: 'Service not found.' });
            }

            return res.status(200).json(updatedService);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }
}