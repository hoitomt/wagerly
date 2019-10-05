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
