# Response
## repo description
the required api are implemented by ruby on rails in simple api mode.

1. all code are in the [phantom_mask_backend](https://github.com/yung0512/phantom_mask_backend) repo.
2. api document is in  the repo `doc/api.md` [url](https://github.com/yung0512/phantom_mask_backend/blob/main/doc/api.md)
3. to run the backend server local, please check 
  

## A. Required Information
### A.1. Requirement Completion Rate
- [x] List all pharmacies open at a specific time and on a day of the week if requested.
  - Implemented at POST /pharmacies API.
- [x] List all masks sold by a given pharmacy, sorted by mask name or price.
  - Implemented at GET /pharmacy_masks API.
- [x] List all pharmacies with more or less than x mask products within a price range.
  - Implemented at POST /pharmacies API.
- [x] The top x users by total transaction amount of masks within a date range.
  - Implemented at GET /users/top_n API.
- [x] The total number of masks and dollar value of transactions within a date range.
  - Implemented at GET /mask_transactions API.
- [ ] Search for pharmacies or masks by name, ranked by relevance to the search term.
  - Implemented at xxx API.
- [x] Process a user purchases a mask from a pharmacy, and handle all relevant data changes in an atomic transaction.
  - Implemented at POST /mask_transactions API.
### A.2. API Document
please check on [hackmd](https://hackmd.io/9mWlEBbIQdGE69uQuHLHZw)

### A.3. Import Data Commands
Please run these two script commands to migrate the data into the database.

```bash
$ bundle exec rake db:load_pharmacy
$ bundle exec rake db:load_user
```
## B. Bonus Information

### B.2. Docker develop enviroment

there are a simple docker-compose.yml in backend repo, you can run the backend by docker compose once docker is installed on your machine.

```shell
docker compose up -d # run docker compose in the background
docker compose exec db:migrate
docker compose exec rake db:load_pharmacy # load raw data in db
docker compose exec rake db:load_user
```

### B.3. Demo Site Url
https://nckuopen.com/phantom_mask/api
description:
the backend repo is running on the linode vps with docker compose.

