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
    puts "#{i}  #{line}"
    i = i + 1
  }
  File.open("./server.js", "w+") do |f|
    f.write CoffeeScript.compile(string, {:bare => true})
    puts "DONE"
  end
end
