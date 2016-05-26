require_relative 'schemas/event_vals'

module Validator::Schemas
  EVENT_TYPES_1S_WAREHOUSE_IN = %w{ UserTSDUpdated WarehouseUpdated WarehouseCellUpdated BarcodeManufactured BarcodeMoved }
  EVENT_TYPES_1S_WAREHOUSE_OUT = %w{ ShipmentTicketCreated ShipmentTicketCollected ShipmentTicketConfirmed ShipmentTicketCancelled }
  EVENT_TYPES_TSD = %w{ TSD_BarcodeMoved
                        TSD_ShipmentTicketAccepted
                        TSD_ShipmentTicketCollected
                        TSD_ShipmentTicketConfirmed
                        TSD_ShipmentTickedAssemblyCancelled
                        TSD_ShipmentTickedCancelled }

  T_EVENT_TYPE = {type: "enum"}

  T_EVENT = {
      namespace: "pik.barcode.events",
      name: "EventName",
      type: "record",
      fields: [{name: "event_key", type: "string"}]
  }

  EVENT_VALS = {
      'UserTSDUpdated' => VAL_USERTSDUPDATED,
      'WarehouseUpdated' => VAL_WAREHOUSEUPDATED,
      'WarehouseCellUpdated' => VAL_WAREHOUSECELLUPDATED,
      'BarcodeManufactured' => VAL_BARCODEMANUFACTURED,
      'BarcodeMoved' => VAL_BARCODEMOVED,
      'TSD_BarcodeMoved' => VAL_TSD_BARCODEMOVED,
      'ShipmentTicketCreated' => VAL_SHIPMENTTICKETCREATED,
      'ShipmentTicketCollected' => VAL_SHIPMENTTICKETCOLLECTED,
      'ShipmentTicketConfirmed' => VAL_SHIPMENTTICKETCONFIRMED,
      'ShipmentTicketCancelled' => VAL_SHIPMENTTICKETCANCELLED,
      'TSD_ShipmentTicketAccepted' => VAL_TSD_SHIPMENTTICKETACCEPTED,
      'TSD_ShipmentTicketCollected' => VAL_TSD_SHIPMENTTICKETCOLLECTED,
      'TSD_ShipmentTicketConfirmed' => VAL_TSD_SHIPMENTTICKETCONFIRMED,
      'TSD_ShipmentTicketAssemblyCancelled' => VAL_TSD_SHIPMENTTICKETASSEMBLYCANCELLED,
      'TSD_ShipmentTicketCancelled' => VAL_TSD_SHIPMENTTICKETCANCELLED
  }

  module_function

  def get(name)
    @@all_schemas ||= (EVENT_TYPES_1S_WAREHOUSE_IN | EVENT_TYPES_1S_WAREHOUSE_OUT | EVENT_TYPES_TSD).reduce({}) { |acc, et| acc[et] = _create_schema(et); acc }
    @@all_schemas[name]
  end

  def _create_template_schema(name)
    event_type = T_EVENT_TYPE.merge({symbols: [name]}).merge({name: "EventType#{name}"})
    event = _deep_copy T_EVENT.merge({name: name})
    event[:fields] << {name: "event_type", type: event_type}
    event[:fields] << {name: "event_val", type: EVENT_VALS[name]}
    return event
  end

  def _deep_copy(obj)
    Marshal.load Marshal.dump(obj)
  end

  def _create_schema(name)
    Avro::Schema.parse _create_template_schema(name).to_json
  end
end
