import { ExpressBabysitterHandler } from '../internal/handler/express/babysitter.js';
import { BabysitterRepository } from '../internal/repository/knex/babysitter.js';
import { BabysitterService } from '../internal/service/babysitter.js';
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
        user: 'user',
        password: 'password',
        database: 'db',
    },
});

const babysitterRepository = new BabysitterRepository({ db: knexDbConnection });

const babysitterService = new BabysitterService({ babysitterRepository });

const babysitterHandler = new ExpressBabysitterHandler({ babysitterService });

app.get('/', (_, res) => {
    res.send('hello world from babysitter server 8)');
});

app.get('/babysitters/:user_id', babysitterHandler.getByID.bind(babysitterHandler));
app.get('/babysitters', babysitterHandler.list.bind(babysitterHandler));
app.post('/babysitters', babysitterHandler.create.bind(babysitterHandler));
app.patch('/babysitters/:user_id', babysitterHandler.update.bind(babysitterHandler));

app.listen(port, () => {
    console.log(`server starting at http://127.0.0.1:${port}`);
});
