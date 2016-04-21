require 'avro'
require 'json'

module Validator; end

require_relative 'validator/schemas'
require_relative 'validator/event'

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
