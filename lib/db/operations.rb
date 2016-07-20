require 'json'
require 'connection_pool'

module Db
  EVENT_LOG_1S = 'EventLog1S'
  EVENT_LOG_SRV = 'EventLogSRV'
  EVENT_LOGS = %w{EventLogTest EventLog1S EventLogTSD}
  TOP_QUERY_RECORS = 1000
  SRV_EVENT_DAY_SHIFT = -3

  module_function

  def init(params={})
    @@db_pool = ConnectionPool.new(size: 5, timeout: 5) { MSSql.new(params) }
  end

  def pool
    @@db_pool
  end

  def get_events(device_guid, offset=0)
    r, err = [], nil
    sql_event_type = "(\'#{_event_types_for_device(device_guid).join('\',\'')}\')"
    sql = "SELECT TOP #{TOP_QUERY_RECORS} * FROM #{EVENT_LOG_1S} where offset > ? AND event_type IN #{sql_event_type} ORDER BY offset"

    pstmt, rs = nil, nil

    pool.with do |con|
      pstmt = con.prepare_statement sql
      pstmt.setLong(1, offset)
      rs = pstmt.executeQuery
    end

    r, err = _events rs
  rescue Exception => e
    r = []
    err = e.message
  ensure
    rs.close if rs
    pstmt.close if pstmt
    return [r, err]
  end

  def get_srv_events(device_guid, offset=0)
    r, err = [], nil
    sql_event_type = "(\'#{_event_types_for_device(device_guid).join('\',\'')}\')"
    sql = "SELECT * FROM #{EVENT_LOG_SRV} where created_at >= CAST(DATEADD(day, #{SRV_EVENT_DAY_SHIFT}, GETUTCDATE()) AS date) AND offset > ? AND event_type IN #{sql_event_type} ORDER BY offset"

    pstmt, rs = nil, nil

    pool.with do |con|
      pstmt = con.prepare_statement sql
      pstmt.setLong(1, offset)
      rs = pstmt.executeQuery
    end

    r, err = _events rs
  rescue Exception => e
    r = []
    err = e.message
  ensure
    rs.close if rs
    pstmt.close if pstmt
    return [r, err]
  end

  def get_events_rest(device_guid, offset=0)
    r = nil
    sql_event_type = "(\'#{_event_types_for_device(device_guid).join('\',\'')}\')"
    sql = "SELECT count(offset) as rest FROM #{EVENT_LOG_1S} where offset > ? AND event_type IN #{sql_event_type}"

    pstmt, rs = nil, nil

    pool.with do |con|
      pstmt = con.prepare_statement sql
      pstmt.setLong(1, offset)
      rs = pstmt.executeQuery
    end

    while rs.next
      r = rs.getLong('rest')
    end

  rescue Exception => e
    err = e.message
  ensure
    rs.close if rs
    pstmt.close if pstmt
    return [r, err]
  end

  def _event_types_for_device(device_guid)
    Validator::Schemas::EVENT_TYPES_1S_WAREHOUSE_IN | Validator::Schemas::EVENT_TYPES_1S_WAREHOUSE_OUT | Validator::Schemas::EVENT_TYPES_SRV
  end

  # require 'pry'

  def add_events(events=[])
    valid_events, err = _validate_events(events)
    added_event_keys, db_err = pool.with do |con|
      _add_events_db(con, valid_events)
    end

    [added_event_keys, err + db_err]
  end

  def _validate_events(events)
    err = []
    r = events.select do |event|
      valid = Validator::Event.valid? event
      err << {event_key: event['event_key'], message: 'invalid event'} unless valid
      valid
    end
    [r, err]
  end

  def _add_events_db(connection, events)
    r, err = [], []

    pstmts = _init_prepare_statements(connection)
    events.each do |event|
      db_r, db_err = _add_event_db(_get_pstmt_by(event['event_type'], pstmts), event)
      if db_err
        err << {event_key: event['event_key'], message: db_err}
      else
        r << db_r
      end
    end
  rescue Exception => e
    err << e.message
  ensure
    pstmts.each_value { |pstmt| pstmt.close if pstmt }
    return [r, err]
  end

  def _init_prepare_statements(connection)
    {
        tsd: connection.prepare_statement("INSERT INTO EventLogTSD (event_key, event_type, event_val) VALUES (?, ?, ?)"),
        srv: connection.prepare_statement("INSERT INTO EventLogSRV (event_key, event_type, event_val) VALUES (?, ?, ?)"),
        sta: connection.prepare_statement("INSERT INTO EventLogSTAT (event_key, event_type, event_val) VALUES (?, ?, ?)"),
        one_s: connection.prepare_statement("INSERT INTO EventLog1S (event_key, event_type, event_val) VALUES (?, ?, ?)")
    }
  end

  def _get_pstmt_by(event_type, prepared_statments)
    key = case event_type[0..2]
      when 'TSD' then :tsd
      when 'SRV' then :srv
      when 'STA' then :sta
      else :one_s
    end
    prepared_statments[key]
  end

  def _add_event_db(pstmt, event)
    event_key = event['event_key']
    pstmt.setNString(1, event_key)
    pstmt.setNString(2, event['event_type'])
    pstmt.setNString(3, event['event_val'].to_json)
    pstmt.executeUpdate
    [event_key, nil]
  rescue Exception => e
    return [nil, e.message]
  end

  def _events(result_set)
    r, db_err = [], []
    while result_set.next
      ev = _event(result_set)
      if Validator::Event.valid? JSON(ev.to_json)
        r << ev
      else
        db_err << {event_key: ev[:event_key], message: "invalid event into DB"}
      end
    end
    err = db_err.empty? ? nil : db_err
    return [r, err]
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
