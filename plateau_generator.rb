def generator
  File.open('./plateau.txt', 'w') { |f| f.truncate(0) }
  if ARGV.count != 3
    puts 'params needed: x y density'
    exit
  end

  x = ARGV[0].to_i
  y = ARGV[1].to_i
  density = ARGV[2].to_i


  (0..y).each do
    (0..x).each do
      File.open('./plateau.txt', 'a') { |f| f.write(rand(y) * 2 < density ? 'x' : '.') }
    end
    File.open('./plateau.txt', 'a') { |f| f.write("\n") }
  end
  puts 'New board generated in ./plateau.txt'
end

generator
