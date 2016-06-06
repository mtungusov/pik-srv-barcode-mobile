module Validator::Schemas
  VAL_USERTSDUPDATED = {
      name: "EventValUserTSDUpdated",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "fullname", type: "string"},
          {name: "barcode", type: "string"},
          {
              name: "warehouses",
              type:
                  {
                      type: "array",
                      name: "Warehouse",
                      items: {
                          type: "record",
                          name: "WarehouseElement",
                          fields: [
                              {name: "guid", type: "string"},
                              {name: "name", type: "string"}
                          ]
                      }
                  }
          }
      ]
  }

  VAL_WAREHOUSEUPDATED = {
      name: "EventValWarehouseUpdated",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "name", type: "string"},
      ]
  }

  VAL_WAREHOUSECELLUPDATED = {
      name: "EventValWarehouseCellUpdated",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "warehouse_guid", type: "string"},
          {name: "name", type: "string"},
          {name: "barcode", type: "string"}
      ]

  }

  VAL_BARCODEMANUFACTURED = {
      name: "EventValBarcodeManufactured",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "nomenclature", type: "string"},
          {name: "warehouse_guid", type: "string"},
          {name: "warehouse_name", type: "string"},
          {name: "change_at", type: "long"}
      ]
  }

  VAL_BARCODEMOVED = {
      name: "EventValBarcodeMoved",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "nomenclature", type: "string"},
          {name: "warehouse_guid", type: "string"},
          {name: "warehouse_name", type: "string"},
          {name: "cell_guid", type: "string"},
          {name: "cell_name", type: "string"},
          {name: "change_at", type: "long"}
      ]
  }

  VAL_TSD_BARCODEMOVED = {
      name: "EventValTSD_BarcodeMoved",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "nomenclature", type: "string"},
          {name: "warehouse_guid", type: "string"},
          {name: "warehouse_name", type: "string"},
          {name: "cell_guid", type: "string"},
          {name: "cell_name", type: "string"},
          {name: "warehouse_from_guid", type: "string"},
          {name: "warehouse_from_name", type: "string"},
          {name: "cell_from_guid", type: "string"},
          {name: "cell_from_name", type: "string"},
          {name: "user_guid", type: "string"},
          {name: "user_fullname", type: "string"},
          {name: "change_at", type: "long"}
      ]
  }

  VAL_SHIPMENTTICKETCREATED = {
      name: "EventValShipmentTicketCreated",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "warehouse_guid", type: "string"},
          {name: "warehouse_name", type: "string"},
          {name: "transport_plate", type: "string"},
          {name: "change_at", type: "long"},
          {
              name: "items",
              type:
                  {
                      type: "array",
                      name: "ShipmentTicketItems",
                      items: {
                          type: "record",
                          name: "ShipmentTicketItem",
                          fields: [
                              {name: "guid_nomenclature", type: "string"},
                              {name: "nomenclature", type: "string"}
                          ]
                      }
                  }
          }
      ]
  }

  VAL_SHIPMENTTICKETCOLLECTED = {
      name: "EventValShipmentTicketCollected",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "warehouse_guid", type: "string"},
          {name: "warehouse_name", type: "string"},
          {name: "transport_plate", type: "string"},
          {name: "user_guid", type: "string"},
          {name: "user_fullname", type: "string"},
          {name: "change_at", type: "long"},
          {
              name: "items_loaded",
              type:
                  {
                      type: "array",
                      name: "ShipmentTicketItems",
                      items: {
                          type: "record",
                          name: "ShipmentTicketCollectedItem",
                          fields: [
                              {name: "barcode", type: "string"},
                              {name: "guid_nomenclature", type: "string"},
                              {name: "nomenclature", type: "string"}
                          ]
                      }
                  }
          },
          {
              name: "items_not_loaded",
              type:
                  {
                      type: "array",
                      name: "ShipmentTicketItems",
                      items: {
                          type: "record",
                          name: "ShipmentTicketCollectedNotLoadedItem",
                          fields: [
                              {name: "guid_nomenclature", type: "string"},
                              {name: "nomenclature", type: "string"}
                          ]
                      }
                  }
          }
      ]
  }

  VAL_SHIPMENTTICKETCONFIRMED = {
      name: "EventValShipmentTicketConfirmed",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "transport_plate", type: "string"},
          {name: "change_at", type: "long"},
      ]
  }

  VAL_SHIPMENTTICKETCANCELLED = {
      name: "EventValShipmentTicketCancelled",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "transport_plate", type: "string"},
          {name: "change_at", type: "long"},
      ]
  }

  VAL_TSD_SHIPMENTTICKETACCEPTED = {
      name: "EventValTSD_ShipmentTicketAccepted",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "warehouse_guid", type: "string"},
          {name: "warehouse_name", type: "string"},
          {name: "transport_plate", type: "string"},
          {name: "user_guid", type: "string"},
          {name: "user_fullname", type: "string"},
          {name: "change_at", type: "long"}
      ]
  }

  VAL_TSD_SHIPMENTTICKETCOLLECTED = {
      name: "EventValTSD_ShipmentTicketCollected",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "warehouse_guid", type: "string"},
          {name: "warehouse_name", type: "string"},
          {name: "transport_plate", type: "string"},
          {name: "user_guid", type: "string"},
          {name: "user_fullname", type: "string"},
          {name: "change_at", type: "long"},
          {
              name: "items_loaded",
              type:
                  {
                      type: "array",
                      name: "ShipmentTicketItems",
                      items: {
                          type: "record",
                          name: "ShipmentTicketTSDCollectedItem",
                          fields: [
                              {name: "barcode", type: "string"},
                              {name: "nomenclature", type: "string"}
                          ]
                      }
                  }
          }
      ]
  }

  VAL_TSD_SHIPMENTTICKETCONFIRMED = {
      name: "EventValTSD_ShipmentTicketConfirmed",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "user_guid", type: "string"},
          {name: "user_fullname", type: "string"},
          {name: "change_at", type: "long"}
      ]
  }

  VAL_TSD_SHIPMENTTICKETASSEMBLYCANCELLED = {
      name: "EventValTSD_ShipmentTicketAssemblyCancelled",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "user_guid", type: "string"},
          {name: "user_fullname", type: "string"},
          {name: "change_at", type: "long"}
      ]
  }

  VAL_TSD_SHIPMENTTICKETCANCELLED = {
      name: "EventValTSD_ShipmentTicketCancelled",
      type: "record",
      fields: [
          {name: "guid", type: "string"},
          {name: "user_guid", type: "string"},
          {name: "user_fullname", type: "string"},
          {name: "change_at", type: "long"}
      ]
  }

end
