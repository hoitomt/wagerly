deploy:
	git push origin master
	git push heroku master
	heroku run rake db:migrate
	heroku config:set START_DATE=2017-07-01
	heroku config:set STOP_DATE=2018-06-30
