require 'lexeme'
# Represents a scanner for Bruhcode expressions
class Scanner

  attr_reader :source, :tokens

  def initialize(source)
    @source = source
  end

  def scan_tokens
    lexer = Lexeme.define do
      token LEFT_PAREN: /^\($/
      token RIGHT_PAREN: /^\)$/
      token LEFT_BRACE: /^{$/
      token RIGHT_BRACE: /^}$/
      token COMMA: /^,$/
      token DOT: /^\.$/
      token MINUS: /^-$/
      token PLUS: /^\+$/
      token SEMICOLON: /^;$/
      token TIMES: /^\*$/
      token DIV: %r{^/$}

      token BANG: /^!$/
      token BANG_EQUAL: /^!=$/

      token EQUAL: /^=$/
      token IS: /^is$/
      token EQUAL_EQUAL: /^==$/
      token IS_TOTALLY: /^is_totally$/

      token LESS_THAN: /^<$/
      token LESS_THAN_EQUAL: /^<=$/

      token GREATER_THAN: /^>$/
      token GREATER_THAN_EQUAL: /^>=$/

      token NUMBER: /^\d+\.?\d?$/

      # Identifiers
      token PRINT: /^yooo$/
      token TRUE: /^yea$/
      token FALSE: /^nah$/
      token VAR: /^like$/

      token RESERVED: /^(fin|print|func|)$/
      token STRING: /^".*"$/
      token ID: /^[\w_"]+$/


    end

    src = source
    tokens = lexer.analyze do
      from_string src
    end

    tokens.each do |t|
      puts "#{t.line} => #{t.name}: #{t.value}"
    end

    tokens
  end
end
