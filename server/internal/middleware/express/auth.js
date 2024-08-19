export class ExpressAuthMiddleware {
    constructor({ authService }) {
        this.authService = authService;
    }

    async authenticate(req, res, next) {
        const authHeader = req.headers.authorization;

        if (!authHeader) {
            return res.status(403).json({ message: 'Token not provided.' });
        }

        const [type, token] = authHeader.split(' ');

        if (type !== 'Bearer') {
            return res.status(403).json({ message: 'Invalid token type. Expected: \'Bearer\'' });
        }

        try {
            const payload = await this.authService.decodeToken(token);

            req.user = {
                id: payload.user_id,
                email: payload.email
            };

            return next();
        } catch (error) {
            return res.status(401).json({ message: error.message });
        }
    }
}