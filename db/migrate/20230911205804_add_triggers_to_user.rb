class AddTriggersToUser < ActiveRecord::Migration[7.0]
  def up
    create_function_sql = <<~SQL
      CREATE OR REPLACE FUNCTION set_users_special_field()
        RETURNS TRIGGER
        LANGUAGE PLPGSQL
        AS
      $$
      BEGIN
        NEW.special_field = 'special:' || random()::text;

        RETURN NEW;
      END;
      $$
    SQL

    create_trigger_sql = <<~SQL
      CREATE TRIGGER set_users_special_field_trigger
        BEFORE UPDATE
        ON users
        FOR EACH ROW
        EXECUTE PROCEDURE set_users_special_field();
    SQL

    execute(create_function_sql)
    execute(create_trigger_sql)
  end

  def down
    execute('DROP trigger IF EXISTS set_users_special_field_trigger ON users')
    execute('DROP function IF EXISTS set_users_special_field()')
  end
end
