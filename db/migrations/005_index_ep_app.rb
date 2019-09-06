Sequel.migration do
  no_transaction

  up do
    run <<-EOS
      CREATE INDEX CONCURRENTLY index_events_on_ep_app ON events(ep_app);
    EOS
  end

  down { run "DROP INDEX index_events_on_ep_app;" }
end
