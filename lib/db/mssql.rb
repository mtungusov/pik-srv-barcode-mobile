module Db
  class MSSql
    DB_DS = Java::com.microsoft.sqlserver.jdbc::SQLServerDataSource
    # attr_reader :con

    def initialize(params)
      @ds = _get_ds params
      connect
    end

    def connect
      @con = @ds.getConnection
    end

    def get
      connect if @con and @con.closed?
      @con
    end

    def close
      @con.close
    end

    def _get_ds(host:, db:, user:, pass:)
      ds = DB_DS.new
      ds.setServerName host
      ds.setDatabaseName db
      ds.setUser user
      ds.setPassword pass
      ds
    end
  end
end
