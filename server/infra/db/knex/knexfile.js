import dotenv from 'dotenv';

dotenv.config();

const dbHost = process.env.DB_HOST || '127.0.0.1';
const dbPort = process.env.DB_PORT || 3306;
const dbUser = process.env.DB_USER || 'babysitter_admin';
const dbPassword = process.env.DB_PASSWORD || 'babysitter_password';
const dbName = process.env.DB_NAME || 'babysitter';

export default {
  client: 'mysql',
  connection: {
    host: dbHost,
    port: dbPort,
    user: dbUser,
    password: dbPassword,
    database: dbName,
  },
  migrations: {
    tableName: 'knex_migrations'
  },
};
