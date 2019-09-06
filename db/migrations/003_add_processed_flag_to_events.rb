Sequel.migration do
  no_transaction

  up do
    run <<-EOS
      ALTER TABLE events ADD COLUMN processed_at TIMESTAMP WITH TIME ZONE;
    EOS

    run <<-EOS
      CREATE INDEX CONCURRENTLY events_processed_at ON events(processed_at);
    EOS
  end

  down { run "ALTER TABLE events DROP COLUMN processed_at;" }
end
