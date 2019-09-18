require "logeater"

module Processing

  def self.perform!(app_name)
    events = Logeater::Event.where(ep_app: app_name).unprocessed
    file = Logeater::EventFile.new(events)
    reader = Logeater::Reader.new(app_name, file, {})

    started_at = Time.now
    removed = reader.remove_existing_entries!
    removed_time = Time.now - started_at

    started_at = Time.now
    imported = reader.import
    imported_time = Time.now - started_at

    { removed: removed, removed_time: removed_time, imported: imported, imported_time: imported_time }
  end

end
