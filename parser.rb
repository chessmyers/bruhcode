# Parses Bruhcode expressions
class Parser

  class ParseError < RuntimeError; end

  attr_accessor :tokens, :current

  def initialize(tokens)
    @tokens = tokens
    @current = 0
  end

  def parse
    begin
      return expression
    rescue ParseError => e
      return nil
    end
  end

  private

  # So we want to start parsing tokens to derive an overall expression
  def expression
    equality
  end

  # We move down the chain in reverse order of operations.
  # Equality has the LOWEST precedence of any operators, so we check that first (!=, ==)
  def equality
    expr = comparison

    while match(:BANG_EQUAL, :EQUAL_EQUAL)
      operator = previous
      right = comparison
      expr = Expression::Binary.new(expr, operator, right)
    end

    expr
  end

  # Next up is comparison, with second-lowest precedence (<, <=, >, >=)
  def comparison
    expr = term

    while match(:GREATER, :GREATER_EQUAL, :LESS, :LESS_EQUAL)
      operator = previous
      right = term
      expr = Expression::Binary.new(expr, operator, right)
    end

    expr
  end

  # Addition + subtraction have lower precedence
  def term
    expr = factor

    while match(:PLUS, :MINUS)
      operator = previous
      right = factor
      expr = Expression::Binary.new(expr, operator, right)
    end

    expr
  end

  # ...than division and multiplication
  def factor
    expr = unary

    while match(:DIV, :TIMES)
      operator = previous
      right = unary
      expr = Expression::Binary.new(expr, operator, right)
    end

    expr
  end

  def unary
    if match(:BANG, :MINUS)
      operator = previous
      right = unary
      return Expression::Unary.new(operator, right)
    end

    primary
  end

  def primary
    return Expression::Literal.new(false) if match :FALSE
    return Expression::Literal.new(true) if match :TRUE
    return Expression::Literal.new(nil) if match :NULL

    return Expression::Literal.new(previous.value) if match(:NUMBER, :STRING)

    if match(:LEFT_PAREN)
      expr = expression
      consume(:RIGHT_PAREN, "Expect ')' after expression.");
      Expression::Grouping.new expr
    end

    raise error(peek, "Expect expression")
  end

  def consume(token_type, message)
    return advance if check token_type

    raise error(peek, message)
  end

  def error(token, message)
    BruhCode.token_error(token, message)

    ParseError.new
  end

  def synchronize
    advance

    until is_at_end
      return if previous.name == :SEMICOLON

      case peek.name
      when :CLASS
      when :FUN
      when :VAR
      when :FOR
      when :IF
      when :WHILE
      when :PRINT
      when :RETURN
        return
      end

      advance
    end
  end

  def check(token_type)
    return false if is_at_end

    peek.name == token_type
  end

  def match(*token_types)
    token_types.each do |tt|
      if check tt
        advance
        return true
      end
    end

    false
  end

  def advance
    @current += 1 unless is_at_end
    previous
  end

  def is_at_end
    peek.nil? || peek.name == :EOF
  end

  def peek
    tokens[current]
  end

  def previous
    tokens[current.pred]
  end
end
