class Expression

  # Visitor interface
  class Visitor
    def visit_literal_expr
      raise NotImplementedError, 'Must implement visit_literal_expr'
    end

    def visit_literal_expr
      raise NotImplementedError, 'Must implement visit_literal_expr'
    end

    def visit_binary_expr
      raise NotImplementedError, 'Must implement visit_binary_expr'
    end

    def visit_unary_expr
      raise NotImplementedError, 'Must implement visit_unary_expr'
    end
  end

  # Represents a binary expression (left hand and right hand operator)
  class Binary < Expression
    attr_reader :left, :operator, :right

    def initialize(left, operator, right)
      @left = left
      @operator = operator
      @right = right
    end

    def accept(visitor)
      visitor.visit_binary_expr(self)
    end
  end

  # Represents a grouping of other expressions, like within parentheses
  class Grouping < Expression
    attr_reader :expression

    def initialize(expression)
      @expression = expression
    end

    def accept(visitor)
      visitor.visit_grouping_expr(self)
    end

  end

  # Represents a literal expression, such as a number or string
  class Literal < Expression
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def accept(visitor)
      visitor.visit_literal_expr(self)
    end
  end

  # Represents a unary expression (only one value given)
  class Unary < Expression
    attr_reader :operator, :right

    def initialize(operator, right)
      @operator = operator = operator
      @right = right
    end

    def accept(visitor)
      visitor.visit_unary_expr(self)
    end
  end

end