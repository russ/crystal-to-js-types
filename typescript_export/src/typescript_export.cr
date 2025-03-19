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
      "Nil"                  => "null",
    }

    {% for klass in BaseSerializer.all_subclasses %}
      crystal_to_ts_types[{{klass.name.stringify}}] = {{klass.name.stringify}}
    {% end %}
    {% type = parse_type(t).resolve %}
    {% nilable = type.nilable? ? " | null" : "" %} 

    base_type = {{type.stringify}}.match(/\w+(?:\([\w|, ]+\))?/).try(&.[0]).to_s

    if base_type =~ /Array/
      item_types = base_type.match(/Array\(([\w|, ]+)\)/)
        .try(&.[1]).to_s
        .split(" | ")
        .map { |t| crystal_to_ts_types[t]? || "any" }
      if item_types.size > 1
        "(" + item_types.join(" | ") + ")[]"
      else
        # t = TypeScriptExport.to_typescript_type("#{item_types.first.class}")
        item_types.first + "[]"
      end
    elsif base_type =~ /Hash/
      key_and_type = base_type.match(/Hash\(([\w|, ]+)\)/)
        .try(&.[1]).to_s
        .split(", ")
      key_type = key_and_type.shift
      types = key_and_type.join.split(" | ").map { |t| crystal_to_ts_types[t]? || "any" }
      mapped_key = crystal_to_ts_types[key_type]? || "any"
      "Record<" + mapped_key + ", " + types.join(" | ") + ">"
    else
      mapped = crystal_to_ts_types[base_type]? || "any"
      mapped + {{nilable}}
    end
  end
end

macro generate_typescript_definitions
  {% subclasses = BaseSerializer.all_subclasses %}
  
  {% for klass in BaseSerializer.all_subclasses %}
    {% if klass.annotation(TypeScriptExport::Serializer) %}
      puts "\nexport type #{{{klass.name.stringify}}} = {"

      # Extract all methods with Field annotation
      {% for method in klass.methods %}
        {% if method.annotation(TypeScriptExport::Field) %}
          # Get method name as property name
          field_name = {{method.name.stringify}}
          
          # Get return type
          {% if method.return_type %}
            {% type = parse_type(method.return_type.stringify).resolve %}
            {% nilable = type.nilable? ? "?" : "" %} 
            puts "  #{field_name.camelcase(lower: true)}#{{{nilable}}}: " + TypeScriptExport.to_typescript_type({{method.return_type.stringify}}) + ";"
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
