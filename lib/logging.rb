class Logging
  include Celluloid

  [:debug, :info, :warn, :error].each { |method|
    define_method(method) { |*args| async.log(method,*args) }
  }

  alias :console :info

  def log(method, *args)
    Celluloid::Internals::Logger.send(method,*args)
  end

  def exception(ex, note)
    error("#{note}: #{ex} (#{ex.class})")
    ex.backtrace.each { |line| error("* #{line}") }
  end
end
