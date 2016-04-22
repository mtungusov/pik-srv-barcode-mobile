module Db
  class MSSql
    DB_DS = Java::com.microsoft.sqlserver.jdbc::SQLServerDataSource
    TIMEOUT = 3

    def initialize(params)
      @ds = _get_ds params
    end

    def prepare_statement(args)
      _connection.prepareStatement args
    end

    def close
      @con.close if @con and !@con.closed?
    end

    def _connection
      @con = @ds.getConnection if @con.nil? or !@con.valid?(TIMEOUT)
      @con
    end

    def _get_ds(host:, db:, user:, pass:)
      ds = DB_DS.new
      ds.setServerName host
      ds.setDatabaseName db
      ds.setUser user
      ds.setPassword pass
      ds.setLoginTimeout TIMEOUT
      ds
    end
  end
end
