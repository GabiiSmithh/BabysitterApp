export class ExpressBabysitterHandler {
    constructor({ babysitterService }) {
        this.babysitterService = babysitterService;
    }

    async getByID(req, res) {
        try {
            const babysitter = await this.babysitterService.getByID(req.params.user_id);

            if (!babysitter) {
                return res.status(404).json({ message: 'Babysitter not found.' });
            }

            delete babysitter.password;

            return res.status(200).json(babysitter);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }

    async list(_, res) {
        try {
            const babysitters = await this.babysitterService.list();

            babysitters.forEach(babysitter => {
                delete babysitter.password;
            });

            return res.status(200).json(babysitters);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }

    async create(req, res) {
        try {
            const createBabysitterDTO = {
                name: req.body.name,
                gender: req.body.gender,
                email: req.body.email,
                password: req.body.password,
                cellphone: req.body.cellphone,
                birthDate: req.body.birth_date,
                experienceMonths: req.body.experience_months
            };

            const createdBabysitter = await this.babysitterService.create(createBabysitterDTO);

            delete createdBabysitter.password

            return res.status(201).json(createdBabysitter);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }

    async update(req, res) {
        try {
            const updateBabysitterDTO = {
                id: req.params.user_id,
                name: req.body.name,
                email: req.body.email,
                cellphone: req.body.cellphone,
                experienceMonths: req.body.experience_months,
                rating: req.body.rating,
            };

            const updatedBabysitter = await this.babysitterService.update(updateBabysitterDTO);

            if (!updatedBabysitter) {
                return res.status(404).json({ message: 'Babysitter not found.' });
            }

            delete updatedBabysitter.password;

            return res.status(200).json(updatedBabysitter);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }
}