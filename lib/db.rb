module Db; end

require_relative 'db/mssql'

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
      event_val: row.getNString('event_val')
    }
  end
end
