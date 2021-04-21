# Represents the main module of the interpreter
class BruhCode

  def main
    puts 'Welcome to Bruhcode v1.0'
    puts 'The official programming language of California!'

    loop do
      print '🤙👀 > '
      line = gets
      next if line.chomp.empty?

      run line
    end
  end

  def run(code)

  end

end




BruhCode.new.main