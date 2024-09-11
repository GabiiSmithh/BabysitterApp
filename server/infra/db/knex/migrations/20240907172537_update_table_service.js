/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
export function up(knex) {
    return knex.schema.table('service', function(table) {
      table.jsonb('enrollments').notNullable();
    });
  }
  
  /**
   * @param { import("knex").Knex } knex
   * @returns { Promise<void> }
   */
  export function down(knex) {
    return knex.schema.table('service', function(table) {
      table.dropColumn('enrollments');
    });
  }
  