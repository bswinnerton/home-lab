# NYC Restaurant Grades

This powers https://nyc-restaurant-grades.com, and the source code lives [here](https://github.com/bswinnerton/nyc-restaurant-grades).

When deploying this to a production docker setup, you'll need to:

1. Copy over the `master.key`, which is used for encrypted Rails secrets
2. `cp .env.example .env` and update any applicable variables
