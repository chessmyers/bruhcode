require_relative 'scanner'
require_relative 'interpreter'
require_relative 'parser'
# Represents the main module of the interpreter
class BruhCode

  attr_accessor :had_error, :had_runtime_error, :interpreter

  def initialize
    @had_error = false
    @had_runtime_error = false
    @interpreter = Interpreter.new
  end

  def main
    puts 'Welcome to Bruhcode v1.0'
    puts 'The official programming language of California!'

    loop do
      print '🤙👀 > '
      line = gets
      next if line.chomp.empty?

      run line.chomp
      @had_error = false
    end
  end

  def run(code)
    tokens = Scanner.new(code).scan_tokens
    parser = Parser.new(tokens)
    expression = parser.parse

    return if had_error

    interpreter.interpret expression


  end

  def self.error(line, message)
    report(line, '', message)
  end

  def self.report(line, where, message)
    puts "bruh you're donezo... on line #{line} at #{where}: #{message}"
    @had_error = true
  end

  def self.token_error(token, message)
    if token.name == :EOF
      report(token.line, ' at end', message)
    else
      report(token.line, " at '#{token.value}'", message)
    end
  end

  def self.runtime_error(error)
    puts "bruh we're totally donzezo... there was a runtime error: "
    puts error
    @had_runtime_error = true
  end

end

BruhCode.new.main
