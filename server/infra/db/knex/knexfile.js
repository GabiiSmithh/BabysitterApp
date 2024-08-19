// Update with your config settings.

export default {
  client: 'mysql',
  connection: {
    host: '127.0.0.1',
    port: 3306,
    user: 'user',
    password: 'password',
    database: 'db',
  },
  migrations: {
    tableName: 'knex_migrations'
  },
};
