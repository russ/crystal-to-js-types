module TypeScriptExport
  annotation Serializer
  end

  annotation Field
  end

  macro to_typescript_type(t)
    crystal_to_ts_types = {
      "String"               => "string",
      "Int32"                => "number",
      "Int64"                => "number",
      "Float64"              => "number",
      "Float32"              => "number",
      "Bool"                 => "boolean",
      "Time"                 => "Date",
      "Array(String)"        => "string[]",
      "Array(Int32)"         => "number[]",
      "Hash(String, String)" => "Record<string, string>",
      "Hash(String, Int32)"  => "Record<string, number>",
      "Nil"                  => "null | undefined",
    }

    {% type = parse_type(t).resolve %}
    {% nilable = type.nilable? ? "?" : "" %} 

    base_type = {{type.stringify.gsub(/\((\w+) | Nil\)/, "\\1").split("|").first}}
    mapped = crystal_to_ts_types[base_type]? || "any"
    base_type + {{nilable}}
  end
end

macro generate_typescript_definitions
  {% subclasses = BaseSerializer.all_subclasses %}
  
  {% for klass in BaseSerializer.all_subclasses %}
    {% if klass.annotation(TypeScriptExport::Serializer) %}
      puts "\nexport type #{{{klass.name.stringify}}} {"

      # Extract all methods with Field annotation
      {% for method in klass.methods %}
        {% if method.annotation(TypeScriptExport::Field) %}
          # Get method name as property name
          field_name = {{method.name.stringify}}
          
          # Get return type
          {% if method.return_type %}
            puts " #{field_name.camelcase(lower: true)}: " + TypeScriptExport.to_typescript_type({{method.return_type.stringify}}) + ";"
          {% else %}
            # Default to any if no return type is specified
            puts "  #{field_name}: any;"
          {% end %}
        {% end %}
      {% end %}
      
      puts "}"
    {% end %}
  {% end %}
end
