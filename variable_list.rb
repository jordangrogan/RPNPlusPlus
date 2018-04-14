require_relative 'error'

# Class for the variable list
class VariableList
  # initializes a hashmap to store variables
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

  def check_for_variable(value)
    if @variables.key?(value)
      return true
    else
      return false
    end
  end

end
