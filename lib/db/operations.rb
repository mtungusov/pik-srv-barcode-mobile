require 'json'

module Db
  EVENT_LOGS = %w{EventLogTest EventLog1S EventLogTSD}

  module_function

  def con(params={})
    @@db_con ||= MSSql.new(params).con
  end

  def get_events(event_log_name:, offset: 0)
    r, err = [], nil
    raise 'invalid event log name' unless EVENT_LOGS.include? event_log_name
    sql = "SELECT * FROM #{event_log_name} where offset > ?"

    pstmt = con.prepareStatement sql
    pstmt.setLong(1, offset)
    rs = pstmt.executeQuery

    r = _events rs
  rescue Exception => e
    r = []
    err = e.message
  ensure
    rs.close if rs
    pstmt.close if pstmt
    return [r, err]
  end

  def add_events(event_log_name, events=[])
    return [[], ['invalid event log name']] unless EVENT_LOGS.include? event_log_name
    r, err = [], []

    events.select do |event|
      valid = Validator::Event.valid? event
      err << { event_key: event['event_key'], message: 'invalid event' } unless valid
      valid
    end.each do |event|
      _, db_err = _add_event(event_log_name, event)
      if db_err
        err << {event_key: event['event_key'], message: db_err}
      else
        r << event['event_key']
      end
    end
    return [r, err]
  end

  def _add_event(event_log_name, event)
    r, err = nil, nil
    sql = "INSERT INTO #{event_log_name} (event_key, event_type, event_val) VALUES (?, ?, ?)"

    pstmt = con.prepareStatement sql
    pstmt.setNString(1, event['event_key'])
    pstmt.setNString(2, event['event_type'])
    pstmt.setNString(3, event['event_val'].to_json)

    r = pstmt.executeUpdate
  rescue Exception => e
    err = e.message
  ensure
    pstmt.close if pstmt
    return [r, err]
  end

  def _events(result_set)
    r = []
    while result_set.next
      r << _event(result_set)
    end
    r
  end

  def _event(row)
    {
        offset: row.getLong('offset'),
        event_key: row.getNString('event_key'),
        event_type: row.getNString('event_type'),
        event_val: _event_val(row.getNString('event_val'))
    }
  end

  def _event_val(str)
    result = JSON.parse str.gsub('\\', '')
  rescue
    result = str
  ensure
    return result
  end
end
