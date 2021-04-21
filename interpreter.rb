require_relative 'expression'
# Interprets bruhcode expressions
class Interpreter < Expression::Visitor

  def interpret(expr)
    begin
      value = evaluate(expr)
      puts stringify value
    rescue StandardError => e
      BruhCode.runtime_error e
    end
  end

  def visit_literal_expr(expr)
    expr.value
  end

  def visit_grouping_expr(expr)
    evaluate(expr.expression)
  end

  def visit_unary_expr(expr)
    right = evaluate expr.right

    case expr.operator.name
    when :MINUS
      check_number_operand(expr.operator, right)
      -right
    when :BANG
      !truthy?(right)
    end
  end

  def visit_binary_expr(expr)
    left = evaluate(expr.left)
    right = evaluate(expr.right)

    left = left.to_f if numeric?(left)
    right = right.to_f if numeric?(right)


    case expr.operator.name
    when :GREATER_THAN
      check_number_operands(expr.operator, left, right)
      left > right
    when :GREATER_THAN_EQUAL
      check_number_operands(expr.operator, left, right)
      left >= right
    when :LESS_THAN
      check_number_operands(expr.operator, left, right)
      left < right
    when :LESS_THAN_EQUAL
      check_number_operands(expr.operator, left, right)
      left <= right
    when :MINUS
      check_number_operands(expr.operator, left, right)
      left - right
    when :PLUS
      left + right
    when :TIMES
      check_number_operands(expr.operator, left, right)
      left * right
    when :DIV
      check_number_operands(expr.operator, left, right)
      left / right
    when :BANG_EQUAL
      !vals_equal?(left, right)
    when :EQUAL_EQUAL
      vals_equal?(left, right)
    end
  end

  def evaluate(expr)
    expr.accept(self)
  end

  def stringify(value)
    return "nothin" if value.nil?
    value.to_s
  end

  private

  # The bruhcode notion of truthiness--subject to change
  # false, and null are falsy. Everything else is truthy
  def truthy?(value)
    return false if value.nil? || value.is_a?(FalseClass)

    true
  end

  # The bruhcode notion of equality--subject to change
  # Basically just defers to ruby equality
  def vals_equal?(left, right)
    return true if left.nil? && right.nil?
    return false if left.nil? || right.nil?

    left.eql? right
  end

  def check_number_operand(operator, operand)
    return if operator.is_a?(Numeric)

    raise "#{operator} requires a number"
  end

  def check_number_operands(operator, left, right)
    return if left.is_a?(Numeric) && right.is_a?(Numeric)

    raise "#{operator} requires two numbers"
  end

  def numeric?(val)
    val.match(/\A[+-]?\d+?(_?\d+)*(\.\d+e?\d*)?\Z/) == nil ? false : true
  end
end