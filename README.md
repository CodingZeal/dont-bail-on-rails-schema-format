# Rails schema_format

Sample code used for writing a blog post. It contains three migrations:

- create users table
- add view to query the users table
- add database trigger to the users table

# Running code locally

```
cd dont-bail-on-rails-schema-format
bundle
docker compose up -d
bin/rails db:create db:migrate db:seed
```

The `.env` file contains the database connection string for development and can be loaded via [direnv](https://direnv.net/) or export `DATABASE_URL` instead.
