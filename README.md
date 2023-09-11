# Setup

`.env` contains the database connection string, load via [direnv](https://direnv.net/)

- `brew install direnv`

```
cd dont-bail-on-rails-schema-format
bundle
docker compose up -d
bin/rails db:create db:migrate
bin/rails server
```

# Notes

```
rails new dont-bail-on-rails-schema-format --database=postgresql --skip-test
cd dont-bail-on-rails-schema-format
docker compose up -d
rails generate model User name:string email:string super_secret:string special_field:string
bin/rails db:create db:migrate
```
