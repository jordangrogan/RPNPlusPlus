# Class for the variable list
class VariableList
  def initialize
    @variables = {}
  end

  def variable_exist?(variable_name)
    return @variables.key?(variable_name)
  end

  def set_variable(name, value)
    @variables[name] = value
  end

  def get_variable(name)
    @variables[name]
  end

end
