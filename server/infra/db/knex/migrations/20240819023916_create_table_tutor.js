/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
export function up(knex) {
    return knex.schema
    .createTable('tutor', (table) => {
        table.uuid('user_id').notNullable().references('id').inTable('user').onDelete('CASCADE');
        table.float('rating').notNullable();
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
    .dropTableIfExists('tutor');
}
