require_relative "../processing"

namespace :process do
  desc "Process events from Members logs"
  task :members do
    Processing.perform! "members"
  end

  desc "Process events from Unite logs"
  task :unite do
    Processing.perform! "unite"
  end

  desc "Process events from LSB logs"
  task :lsb do
    Processing.perform! "lsb"
  end
end
