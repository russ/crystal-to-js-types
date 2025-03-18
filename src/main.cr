require "../typescript_export/src/typescript_export.cr"

require "./models/*"
require "./serializers/base_serializer.cr"
require "./serializers/*"

generate_typescript_definitions
