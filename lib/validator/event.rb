module Validator::Event
  module_function

  def valid?(event)
    schema = Validator::Schemas.get event['event_type']
    return false if schema.nil?
    Avro::Schema.validate schema, event
  end
end
