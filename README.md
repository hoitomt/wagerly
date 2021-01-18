# Wagerly

Manage your wagers

## Set the Heroku Configs

```
heroku config:set SB_USERNAME=<username>
heroku config:set SB_PASSWORD=<password>

heroku config:set START_DATE=2017-07-01
heroku config:set STOP_DATE=2018-06-30
```

## Fetch Tickets from Sportsbook

### Fetch all tickets throughout history

```
bundle exec rake tickets:get_all
```

### Fetch tickets for the past 30 days


```
bundle exec rake tickets:get_recent
```

## Development

### Clean Install

1. Create the database
   ```
   docker-compose up
   bundle exec rails db:environment:set RAILS_ENV=development
   bundle exec rails db:create
   bundle exec rails db:schema:load
   bundle exec rails db:migrate

1. Set the credentials as environment variables
   1. Install autoenv: `brew install autoenv`
   1. Copy the env example file: `cp .env.example .env`
   1. Update the SB_USERNAME and SB_PASSWORD attributes in .env
   1. Reload .env `cd .`

1. Run the server: `bails s`

### Tests

1. Run the clean install steps above
1. `bundle exec rspec`
