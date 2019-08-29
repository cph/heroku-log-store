require "config"

MAX_MONTHS = 6

namespace :vacuum do
  desc "Deletes all processed events"
  task events: :environment do
    DB.run <<~SQL
      DELETE FROM events WHERE events.processed_at IS NOT NULL;
    SQL
  end

  desc "Deletes requests older than #{MAX_MONTHS} months old"
  task requests: :environment do
    # We use completed_at column for comparison, since it's indexed
    DB.run <<~SQL
      DELETE FROM requests WHERE requests.completed_at < NOW() - interval '#{MAX_MONTHS} months';
    SQL
  end
end
