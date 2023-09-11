class AddUserReportingView < ActiveRecord::Migration[7.0]
  def up
    sql = <<~SQL
      CREATE VIEW user_reporting_view AS
      SELECT
        id,
        name,
        email,
        -- super_secret,
        special_field,
        created_at,
        updated_at
      FROM users
      WHERE email <> 'admin@example.com';
    SQL

    execute(sql)
  end

  def down
    execute('DROP view IF EXISTS user_reporting_view')
  end
end
