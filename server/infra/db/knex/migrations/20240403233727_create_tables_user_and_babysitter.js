/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
export function up(knex) {
    return knex.schema
    .createTable('user', (table) => {
        table.uuid('id').primary();
        table.string('name').notNullable();
        table.string('email').unique().notNullable();
        table.string('password').notNullable();
        table.date('birth_date');
        table.string('gender', 10);
        table.string('cellphone', 15);
      })
      .createTable('babysitter', (table) => {
        table.uuid('user_id').notNullable().references('id').inTable('user').onDelete('CASCADE');
        table.integer('experience_months').notNullable();
        table.float('rating').notNullable();
      });
}

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
export function down(knex) {
    return knex.schema
    .dropTableIfExists('babysitter')
    .dropTableIfExists('user');
}
