
Sequel.migration do
  transaction

  up do
    run <<-EOS
      ALTER TABLE requests
        RENAME COLUMN update_at TO updated_at;
    EOS
  end

  down { run "ALTER TABLE requests RENAME COLUMN updated_at TO update_at;" }
end
