module Validator
  require 'avro'
  require 'json'
end

module Validator::Schemas
  # EVENT_TYPES = %w{ TSDUserUpdated WarehouseUpdated BarcodeManufactured BarcodeMoved }
  EVENT_TYPES = %w{ TSDUserUpdated }

  S_EVENT_TYPE = {
      type: "enum"
  }

  S_EVENT = {
      namespace: "pik.barcode.events",
      name: "EventName",
      type: "record",
      fields: [{ name: "event_key", type: "string" }]
  }

  S_EVENT_VALS = {
      'TSDUserUpdated' => {
          name: "EventValTSDUserUpdated",
          type: "record",
          fields: [
              {name: "guid", type: "string"},
              {name: "parent_guid", type: "string"},
              {name: "name", type: "string"}
          ]
      }
  }

  module_function

  def schemas(name)
    @@all_schemas ||= EVENT_TYPES.reduce({}) {|acc, et| acc[et] = _create_schema(et); acc }
    @@all_schemas[name]
  end

  def _create_schema(name)
    event_type = S_EVENT_TYPE.merge({symbols: [name]}).merge({name: "EventType#{name}"})
    event = S_EVENT.merge({name: name})
    event[:fields] << {name: "event_type", type: event_type}
    event[:fields] << {name: "event_val", type: S_EVENT_VALS[name]}
    return Avro::Schema.parse event.to_json
  end
end


# e1 = {
#     event_key: "e-001",
#     event_type: "TSDUserUpdated",
#     event_val: {
#         guid: 'u-001',
#         parent_guid: '',
#         name: 'Solodovnik G.B.'
#     }
# }
#
# e1 = {
#     event_key: "e-001",
#     event_type: "TSDUserUpdated",
#     event_val: {
#         guid: 'u-001',
#         name: 'Solodovnik G.B.'
#     }
# }


# schema = Avro::Schema.parse EVENTS.to_json
# Avro::Schema.validate schema, JSON(e1.to_json)
