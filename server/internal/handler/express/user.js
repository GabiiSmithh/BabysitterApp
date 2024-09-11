export class ExpressUserHandler {
    constructor({ userService }) {
        this.userService = userService;
    }
    
    async assignBabysitter(req, res) {
        try {
            const assignBabysitterDTO = {
                userId: req.user.id,
                experienceMonths: req.body.experience_months,
            };

            await this.userService.assignBabysitter(assignBabysitterDTO);
            
            return res.status(201).json();
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }
    
    async assignTutor(req, res) {
        try {
            const assignTutorDTO = {
                userId: req.user.id,
                childrenCount: req.body.children_count,
                address: req.body.address,
            };

            await this.userService.assignTutor(assignTutorDTO);
            
            return res.status(201).json();
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }
}