web: bundle exec ruby server.rb -sv -e $RACK_ENV -p $PORT
release: sequel -m ./db/migrations $DATABASE_URL
