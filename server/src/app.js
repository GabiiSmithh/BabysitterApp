// babysitter imports
import { ExpressBabysitterHandler } from '../internal/handler/express/babysitter.js';
import { BabysitterRepository } from '../internal/repository/knex/babysitter.js';
import { BabysitterService } from '../internal/service/babysitter.js';

// tutor imports
import { ExpressTutorHandler } from '../internal/handler/express/tutor.js';
import { TutorRepository } from '../internal/repository/knex/tutor.js';
import { TutorService } from '../internal/service/tutor.js'

// service imports
import { ExpressServiceHandler } from '../internal/handler/express/service.js';
import { ServiceRepository } from '../internal/repository/knex/service.js';
import { ServiceService } from '../internal/service/service.js'

// user imports
import { ExpressUserHandler } from '../internal/handler/express/user.js'
import { UserRepository } from '../internal/repository/knex/user.js';
import { UserService } from '../internal/service/user.js'

// auth imports
import { ExpressAuthMiddleware } from '../internal/middleware/express/auth.js';
import { ExpressAuthHandler } from '../internal/handler/express/auth.js';
import { AuthService } from '../internal/service/auth.js'

// configuration imports
import express from 'express';
import dotenv from 'dotenv';
import knex from 'knex';
import cors from 'cors';

dotenv.config();

const port = process.env.API_PORT;
const tokenSecret = process.env.TOKEN_SECRET;
const tokenExpiration = process.env.TOKEN_EXPIRATION;

const app = express({ name: 'babysitter-server' });
app.use(express.json());
app.use(cors());

const knexDbConnection = knex({
    client: 'mysql',
    connection: {
        host: '127.0.0.1',
        port: 3306,
        user: 'joao.korczovei',
        password: 'fGGZ7uQtK7ECm!l',
        database: 'babysitter',
    },
});

// service instances
const serviceRepository = new ServiceRepository({ db: knexDbConnection });
const serviceService = new ServiceService({ serviceRepository });
const serviceHandler = new ExpressServiceHandler({ serviceService });

// babysitter instances
const babysitterRepository = new BabysitterRepository({ db: knexDbConnection });
const babysitterService = new BabysitterService({ babysitterRepository, serviceRepository });
const babysitterHandler = new ExpressBabysitterHandler({ babysitterService });

// tutor instances
const tutorRepository = new TutorRepository({ db: knexDbConnection });
const tutorService = new TutorService({ tutorRepository, serviceRepository });
const tutorHandler = new ExpressTutorHandler({ tutorService });

// user instances
const userRepository = new UserRepository({ db: knexDbConnection });
const userService = new UserService({ userRepository });
const userHandler = new ExpressUserHandler({ userService });

// auth instances
const authService = new AuthService({ secretKey: tokenSecret, expiresIn: tokenExpiration });
const authHandler = new ExpressAuthHandler({ userService, authService });
const authMiddleware = new ExpressAuthMiddleware({ authService });

app.get('/', (_, res) => {
    res.send('hello world from babysitter server 8)');
});

// babysitter endpoints
app.get('/babysitters/:user_id', babysitterHandler.getByID.bind(babysitterHandler));
app.get('/babysitters/:user_id/services', babysitterHandler.listServices.bind(babysitterHandler));
app.get('/babysitters', babysitterHandler.list.bind(babysitterHandler));
app.post('/babysitters', babysitterHandler.create.bind(babysitterHandler));
app.patch('/babysitters/:user_id', babysitterHandler.update.bind(babysitterHandler));

// tutor endpoints
app.get('/tutors/:user_id', tutorHandler.getByID.bind(tutorHandler));
app.get('/tutors/:user_id/services', tutorHandler.listServices.bind(tutorHandler));
app.get('/tutors', tutorHandler.list.bind(tutorHandler));
app.post('/tutors', tutorHandler.create.bind(tutorHandler));
app.patch('/tutors/:user_id', tutorHandler.update.bind(tutorHandler));

// service endpoints
app.get('/services/:service_id', serviceHandler.getByID.bind(serviceHandler));
app.get('/services', serviceHandler.list.bind(serviceHandler));
app.post('/services', serviceHandler.create.bind(serviceHandler));
app.patch('/services/:service_id', serviceHandler.update.bind(serviceHandler));
app.post('/services/:service_id/enroll', authMiddleware.authenticate.bind(authMiddleware), serviceHandler.enrollBabysitter.bind(serviceHandler));

// user endpoints
app.post('/users/roles/babysitter', authMiddleware.authenticate.bind(authMiddleware), userHandler.assignBabysitter.bind(userHandler));
app.post('/users/roles/tutor', authMiddleware.authenticate.bind(authMiddleware), userHandler.assignTutor.bind(userHandler));

// auth endpoints
app.post('/auth/login', authHandler.login.bind(authHandler));
app.post('/auth/change-password', authHandler.changePassword.bind(authHandler));

app.listen(port, () => {
    console.log(`server starting at http://127.0.0.1:${port}`);
});
