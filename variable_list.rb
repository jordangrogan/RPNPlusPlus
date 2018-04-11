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
    if is_number?(value)
      return value.to_i
    elsif @variables.key?(value)
      return @variables[value].to_i
    else
      return Error.new "Variable #{value} is not initialized"
    end
  end

end
