/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
export function up(knex) {
    return knex.schema
    .createTable('service', (table) => {
        table.uuid('id').primary();
        table.uuid('babysitter_id').references('user_id').inTable('babysitter').onDelete('CASCADE');
        table.uuid('tutor_id').notNullable().references('user_id').inTable('tutor').onDelete('CASCADE');
        table.date('start_date').notNullable();
        table.date('end_date').notNullable();
        table.float('value').notNullable();
        table.integer('children_count').notNullable();
        table.string('address').notNullable();
      });
}

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
export function down(knex) {
    return knex.schema
    .dropTableIfExists('service');
}
