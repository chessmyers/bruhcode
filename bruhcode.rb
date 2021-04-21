require_relative 'scanner'
# Represents the main module of the interpreter
class BruhCode

  attr_accessor :had_error

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


  end

  def self.error(line, message)
    report(line, '', message)
  end

  def self.report(line, where, message)
    puts "bruh you're donezo... on line #{line} at #{where}: #{message}"
    @had_error = true
  end

  def self.token_error(token, message)
    if token.type == :EOF 
      report(token.line, ' at end', message)
    else
      report(token.line, " at '#{token.lexeme}'", message)
    end
  end

end

BruhCode.new.main
