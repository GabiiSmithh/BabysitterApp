export class ExpressTutorHandler {
    constructor({ tutorService }) {
        this.tutorService = tutorService;
    }

    async getByID(req, res) {
        try {
            const tutor = await this.tutorService.getByID(req.params.user_id);

            if (!tutor) {
                return res.status(404).json({ message: 'Tutor not found.' });
            }

            delete tutor.password;

            return res.status(200).json(tutor);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }

    async list(_, res) {
        try {
            const tutors = await this.tutorService.list();

            tutors.forEach(tutor => {
                delete tutor.password;
            });

            return res.status(200).json(tutors);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }

    async create(req, res) {
        try {
            const createTutorDTO = {
                name: req.body.name,
                gender: req.body.gender,
                email: req.body.email,
                password: req.body.password,
                cellphone: req.body.cellphone,
                birthDate: req.body.birth_date,
                address: req.body.address,
                childrenCount: req.body.children_count,
            };

            const createdTutor = await this.tutorService.create(createTutorDTO);

            delete createdTutor.password

            return res.status(201).json(createdTutor);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }

    async update(req, res) {
        try {
            const updateTutorDTO = {
                id: req.params.user_id,
                name: req.body.name,
                email: req.body.email,
                cellphone: req.body.cellphone,
                address: req.body.address,
                childrenCount: req.body.children_count,
                rating: req.body.rating,
            };

            const updatedTutor = await this.tutorService.update(updateTutorDTO);

            if (!updatedTutor) {
                return res.status(404).json({ message: 'Tutor not found.' });
            }

            delete updatedTutor.password;

            return res.status(200).json(updatedTutor);
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }
}