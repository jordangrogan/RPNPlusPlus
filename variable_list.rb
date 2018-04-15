require_relative 'error'

# Class for the variable list
class VariableList
  # initializes a hashmap to store variables
  def initialize
    @variables = {}
  end

  def variable_initialized?(variable_name)
    @variables.key?(variable_name)
  end

  def set_variable(name, value)
    @variables[name] = value
  end

  def get_variable(name)
    @variables[name]
  end

end
