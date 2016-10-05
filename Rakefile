require 'coffee-script'

task :compile do
  puts "***************************"
  puts "*** compiling server.js ***"
  puts "***************************"
  string = ""
  File.open(File.expand_path(File.join(__FILE__, "..", "./boot/server.coffee")), 'r') do |f|
    string = f.read
  end
  buffer = string
  buffer.each_line do |line|
    if line =~ /\{\{(\w+)\/(\w+)\/?(\w+)?+\}\}/
      reg =  "./#{$1}/#{$2}"
      if $3 then reg = "./#{$1}/#{$2}/#{$3}" end
      Dir.glob("#{reg}.coffee") do |path|
        File.open(File.expand_path(File.join(__FILE__, "..", path)), 'r')  do |_f|
          reg = path.split("./")[1].split(".coffee")[0]
          
          reg.gsub!("/", "\/")
          reg = /{{#{reg}}}/
          
          if line.match(reg)
            puts " ---> parsing #{reg}"
            string.gsub!(reg, _f.read)
          end
        end
      end
    end
  end
  #puts string
  i = 1
  string.each_line {|line|
    puts gray("#{i}  #{line}")
    i = i + 1
  }

  File.open("./server.js", "w+") do |f|
    begin
      code = CoffeeScript.compile(string, {:bare => true})
      f.write code
      green "DONE"
    rescue ExecJS::RuntimeError => e
      puts red(e.to_s)
      line = e.to_s
      line = line.split "SyntaxError: [stdin]:"
      line = line[1].split(":")
      puts "#{red(string.split("\n")[line[0].to_i-1])}"
    end
  end
end

# https://stackoverflow.com/questions/2070010/how-to-output-my-ruby-commandline-text-in-different-colours
def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def gray(text); colorize(text, 36); end
