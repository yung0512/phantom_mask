# README

This README would normally document whatever steps are necessary to get the
application up and running.
* Ruby version: 2.7.3

* Database creation
  mysql version: 5.5.7

* Database initialization


* Services (job queues, cache servers, search engines, etc.)
  no other service is used
* Deployment instructions


# API required
* List all pharmacies open at a specific time and on a day of the week if requested.
* List all masks sold by a given pharmacy, sorted by mask name or price.
* List all pharmacies with more or less than x mask products within a price range.
* The top x users by total transaction amount of masks within a date range.
* The total amount of masks and dollar value of transactions within a date range.
* Search for pharmacies or masks by name, ranked by relevance to the search term.
* Process a user purchases a mask from a pharmacy, and handle all relevant data changes in an atomic transaction.