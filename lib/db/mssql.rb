module Db
  class MSSql
    DB_DS = Java::com.microsoft.sqlserver.jdbc::SQLServerDataSource
    attr_reader :con

    def initialize(params)
      @con = _get_connection params
    end

    def close
      @con.close
    end

    def _get_connection(host:, db:, user:, pass:)
      ds = DB_DS.new
      ds.setServerName host
      ds.setDatabaseName db
      ds.setUser user
      ds.setPassword pass
      ds.getConnection
    end
  end
end
