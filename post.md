# Understanding Schema Formats in Ruby on Rails: SQL vs. Ruby

In Ruby on Rails applications the schema.rb file acts as a representation of your database schema in Ruby code.
It provides a concise and human-readable way to define the structure of your database tables, columns, indexes, and constraints using Ruby DSL (Domain-Specific Language) statements.

The schema.rb file is updated whenever you run database migrations (`bin/rails db:migrate`).
Rails inspects the database after each migration and updates schema.rb to reflect the current state of the schema.

When you create a new database or reset an existing one Rails uses the schema.rb file to recreate the database structure. You may find yourself rebuilding your development or test databases often; i.e.:

- `bin/rails db:setup` or `bin/rails db:reset` or the long winded version
- `bin/rails db:drop db:create db:schema:load db:seed`

## Schema formats

By default Rails applications use the `:ruby` schema format and save your schema to `db/schema.rb`.
This format is database agnostic, you can use it for PostgreSQL, MySQL, etc.

The `:sql` schema format is database specific and saves your schema to `db/structure.sql`.
Rails will shell out to database specific tools to generate the file; for PostgreSQL it will use `pg_dump`.

## Configuring the schema format

If you want to use `:sql` format, add this line to your `config/application.rb` file:

```rb
config.active_record.schema_format = :sql
```

## Why would you use the SQL format?

The `:ruby` format will meet the needs of most applications.
You should use `:sql` format if your database has database views, triggers or other objects not supported by the `:ruby` schema; for example lets say you need to give read access to a reporting system but want to exclude some columns and or data from being read you might need to introduce database views instead of giving `select` permissions to the tables directly.
Here is a contrived example that hides a column in the `users` table (`super_secret`) and never returns the admin user.

```sql
CREATE VIEW public.user_reporting_view AS
  SELECT users.id,
    users.name,
    users.email,
    users.created_at,
    users.updated_at
  FROM public.users
  WHERE ((users.email)::text <> 'admin@example.com'::text);
```

If we were using the `:ruby` format and rebuilt the database the view would not exist

```sh
bin/rails db:drop db:create db:schema:load db:seed

psql $DATABASE_URL -c "select * from user_reporting_view limit 1;"

    ERROR:  relation "user_reporting_view" does not exist
    LINE 1: select * from user_reporting_view limit 1;
```

Using the `:sql` format all database objects will be created

```sh
bin/rails db:drop db:create db:schema:load db:seed

psql $DATABASE_URL -c "select * from user_reporting_view limit 1;"

 id | name |      email      |         created_at         |         updated_at
----+------+-----------------+---------------+----------------------------+-----------
  1 | FOO  | foo@example.com | 2023-09-11 21:19:23.104644 | 2023-09-11 21:19:23.104644
(1 row)
```

NOTE: if rebuilding your database from the migrations files instead of schema it would not matter which format you used as the database views would get created from the migrations.

## Issues with SQL format

Rails will run `pg_dump` to generate the structure file everytime you run migrations, this can result in errors if your major version of `pg_dump` is different from the database servers major version of PostgreSQL.

```
pg_dump: error: server version: 15.4 (Debian 15.4-1.pgdg120+1); pg_dump version: 14.1
pg_dump: error: aborting because of server version mismatch
rails aborted!
failed to execute:
pg_dump --schema-only --no-privileges --no-owner --file ./db/structure.sql db_development

Please check the output above for any errors and make sure that `pg_dump` is installed in your PATH and has proper permissions.


Tasks: TOP => db:schema:dump
(See full trace by running task with --trace)
```

This might occur in development if your PostgreSQL server is running in a Docker container with a different database version than your local `pg_dump` version.

## db:schema:load vs db:structure:load

In older versions of Rails you would need to use specific load tasks depending on the format:

- `:ruby` format would use `bin/rails db:schema:load`
- `:sql` format would need to use `bin/rails db:structure:load`

For versions `6.1.x` and higher you should always use `bin/rails db:schema:load` for both formats.

# Resources

- https://guides.rubyonrails.org/configuring.html#config-active-record-schema-format
- https://guides.rubyonrails.org/active_record_migrations.html
- https://blog.saeloun.com/2020/09/30/rails-deprecates-db-structure-commands/
- TODO: github repo
