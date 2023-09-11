# Setup

`.env` contains the database connection string, load via [direnv](https://direnv.net/)

- `brew install direnv`

```
cd dont-bail-on-rails-schema-format
bundle
docker compose up -d
bin/rails db:create db:migrate db:seed
bin/rails server
```

# Notes

```
rails new dont-bail-on-rails-schema-format --database=postgresql --skip-test
cd dont-bail-on-rails-schema-format
docker compose up -d
bin/rails generate model User name:string email:string super_secret:string special_field:string
bin/rails g migration AddUserReportingView
bin/rails db:create db:migrate db:seed
```

- https://guides.rubyonrails.org/configuring.html#config-active-record-schema-format

```
pg_dump: error: server version: 15.4 (Debian 15.4-1.pgdg120+1); pg_dump version: 14.1
pg_dump: error: aborting because of server version mismatch
rails aborted!
failed to execute:
pg_dump --schema-only --no-privileges --no-owner --file /Users/jessehouse/projects/sandbox/dont-bail-on-rails-schema-format/db/structure.sql db_development

Please check the output above for any errors and make sure that `pg_dump` is installed in your PATH and has proper permissions.


Tasks: TOP => db:schema:dump
(See full trace by running task with --trace)
```

`db:structure:load` removed in rails 7, just use `db:schema:load` for both `schema_format`: `:sql`, `:ruby` (default)

```
# schema
# config.active_record.schema_format = :ruby (default)
bin/rails db:drop db:create db:migrate db:seed
# all objects are created
psql $DATABASE_URL -c "select * from user_reporting_view limit 1;"
# expected results
```

```
# rebuild from schema file (db/schema.rb)
bin/rails db:drop db:create db:schema:load db:seed
# schema does have definitions for database objects views, functions and triggers
psql $DATABASE_URL -c "select * from user_reporting_view limit 1;"

    ERROR:  relation "user_reporting_view" does not exist
    LINE 1: select * from user_reporting_view limit 1;
```

```
# structure
# config.active_record.schema_format = :sql
bin/rails db:drop db:create db:migrate db:seed
# all objects are created
psql $DATABASE_URL -c "select * from user_reporting_view limit 1;"
# expected results
```

```
# rebuild from structure file (db/structure.sql)
bin/rails db:drop db:create db:schema:load db:seed
# structure has the definition for all database objects, including our view, function and trigger
psql $DATABASE_URL -c "select * from user_reporting_view limit 1;"
# expected results
```
