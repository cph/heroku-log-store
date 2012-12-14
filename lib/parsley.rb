$LOAD_PATH << File.expand_path('./flavors', __FILE__)

module Parsley

  SyslogKeys = :priority, :syslog_version, :emitted_at, :hostname, :appname, :proc_id, :msg_id, :structured_data, :message

  def self.parser(flavor = :heroku)
    require "flavors/#{flavor.to_s}"
    constantize("Parsley::Flavors::#{flavor.to_s.capitalize}")
  end

  # Shouldn't be referenced directly. Always request a flavor of a parser
  # Parsley.parser(:heroku).new(syslog_str)
  class Parser

    attr_reader :data

    # TODO: make stateless
    def initialize(data)
      @data = data
    end

    def events(&block)
      lines do |line|
        if(matching = line.match(line_regex))
          yield event_data(matching)
        end
      end
    end

    protected

    # Since the Heroku format is the only one I've tested, it's the default until broader
    # flavor support is added
    def line_regex
      @line_regex ||= /\<(\d+)\>(1) (\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00) ([a-z0-9-]+) ([a-z0-9\-\_\.]+) ([a-z0-9\-\_\.]+) \- (.*)$/
    end

    # Break a given packet into individual syslog messages. Default assumes one message per packet
    def lines(&block)
      yield data
    end

    # Default is to assume simple sequential matching
    def event_data(matching)
      event = {}
      event[:priority] = matching[1].to_i
      event[:syslog_version] = matching[2].to_i
      event[:emitted_at] = nil?(matching[3]) ? nil : Time.parse(matching[3]).utc
      event[:hostname] = interpret_nil(matching[4])
      event[:appname] = interpret_nil(matching[5])
      event[:proc_id] = interpret_nil(matching[6])
      event[:msg_id] = interpret_nil(matching[7])
      event[:structured_data] = interpret_nil(matching[8])
      event[:message] = interpret_nil(matching[9])
      event
    end

    def interpret_nil(val)
      nil?(val) ? nil : val
    end

    def nil?(val)
      val == "-"
    end
  end

  # Taken from ActiveSupport::Inflector: http://apidock.com/rails/v3.2.8/ActiveSupport/Inflector/constantize
  def self.constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end
end