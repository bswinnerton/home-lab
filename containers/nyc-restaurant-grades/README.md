# NYC Restaurant Grades

![nycrestaurantgrades](https://user-images.githubusercontent.com/934497/44623687-3b21b300-a8a3-11e8-91fb-9e6cebd68fcc.png)

This powers https://nyc-restaurant-grades.com, and the source code lives [here](https://github.com/bswinnerton/nyc-restaurant-grades).

When deploying this to a production docker setup, you'll need to:

1. Copy over the `master.key`, which is used for encrypted Rails secrets
2. `cp .env.example .env` and update any applicable variables
