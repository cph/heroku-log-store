Sequel.migration do
  transaction

  up do
    run <<-EOS
      CREATE TABLE requests (
        id SERIAL8 PRIMARY KEY,
        app CHARACTER(255) NOT NULL,
        logfile CHARACTER(255) NOT NULL,
        uuid CHARACTER(255) NOT NULL,
        subdomain CHARACTER(255),
        started_at TIMESTAMP WITH TIME ZONE,
        completed_at TIMESTAMP WITH TIME ZONE,
        duration INTEGER,
        http_method CHARACTER(255),
        path TEXT,
        params JSONB,
        controller CHARACTER(255),
        action CHARACTER(255),
        remote_ip CHARACTER(255),
        format CHARACTER(255),
        http_status INTEGER,

        user_id CHARACTER(255),
        tester_bar BOOLEAN,

        created_at TIMESTAMP WITH TIME ZONE NOT NULL,
        update_at TIMESTAMP WITH TIME ZONE NOT NULL
      );

      CREATE INDEX requests_app ON requests(app);
      CREATE INDEX requests_logfile ON requests(logfile);
      CREATE UNIQUE INDEX requests_uuid ON requests(uuid);
      CREATE INDEX requests_controller_actions ON requests(controller, action);
      CREATE INDEX requests_http_status ON requests(http_status);

      CREATE INDEX requests_completed_at ON requests(completed_at);
      CREATE INDEX requests_subdomain ON requests(subdomain);
      CREATE INDEX requests_params ON requests USING gin(params);
    EOS
  end

  down { run "DROP TABLE IF EXISTS requests;" }
end
