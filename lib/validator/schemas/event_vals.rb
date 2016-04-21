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
          {
              name: "cells",
              type:
                  {
                      type: "array",
                      name: "WarehouseCell",
                      items: {
                          type: "record",
                          name: "WarehouseCellElement",
                          fields: [
                              {name: "guid", type: "string"},
                              {name: "barcode", type: "string"},
                              {name: "name", type: "string"}
                          ]
                      }
                  }
          }
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
          {name: "change_at", type: "long"}
      ]
  }
end
