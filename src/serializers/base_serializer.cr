abstract class BaseSerializer
  # Keep track of all serializer subclasses so the macro can iterate over them.
  @@subclasses : Array(BaseSerializer.class) = [] of BaseSerializer.class

  def self.inherited(child : BaseSerializer.class)
    @@subclasses << child
    super
  end

  def self.all_subclasses : Array(BaseSerializer.class)
    @@subclasses
  end

  # Helper to resolve nested types.
  # If a serializer exists for the given type (for example, if "User" has a serializer named "UserSerializer"),
  # then return the interface name ("User"). Otherwise, use the default TypeScript mapping.
  def self.resolve_nested_type(crystal_type : String) : String
    serializer_name = "#{crystal_type}Serializer"
    if @@subclasses.any? { |s| s.name.stringify == serializer_name }
      # Return the nested interface name (without "Serializer" suffix)
      crystal_type
    else
      # Fall back to the mapping provided in TypeScriptExport
      TypeScriptExport.to_typescript_type(crystal_type)
    end
  end

  abstract def render
end
