/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
export function up(knex) {
    return knex.schema
    .createTable('role', (table) => {
        table.string('name').primary();
    })
    .createTable('user_has_roles', (table) => {
        table.uuid('user_id').notNullable().references('id').inTable('user').onDelete('CASCADE');
        table.uuid('role_name').notNullable().references('name').inTable('role').onDelete('CASCADE');
        table.primary(['user_id', 'role_name']);
    })
    .then(() => {
        return knex('role').insert([
            { name: 'tutor' },
            { name: 'babysitter' }
        ]);
    });
}

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
export function down(knex) {
    return knex.schema
    .dropTableIfExists('user_has_roles')
    .dropTableIfExists('role');
}
