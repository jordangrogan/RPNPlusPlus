require_relative 'error'

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

  def check_for_variable(value)
    if @variables.key?(value)
      return true
    else
      return false
    end
  end

  def is_number?(token)
    return true if token == '0' # token string is 0
    return false if token.to_i == 0 # to_i will return 0 if it's not a number
    return true
  end

end
