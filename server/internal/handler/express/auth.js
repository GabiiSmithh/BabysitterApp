export class ExpressAuthHandler {
    constructor({ userService, authService }) {
        this.userService = userService;
        this.authService = authService;
    }
    
    async login(req, res) {
        try {
            const { email, password } = req.body;
            const user = await this.userService.getByEmail(email);

            if (!user) {
                return res.status(401).json({ message: 'Invalid credentials.' });
            }

            if (!await this.authService.validateUserCredentials(user, password)) {
                return res.status(401).json({ message: 'Invalid credentials.' });
            }

            const token = this.authService.generateToken(user);
            
            return res.status(200).json({ token });
        } catch (error) {
            // TODO: return correct status for different cases
            return res.status(400).json({ message: error.message });
        }
    }
}