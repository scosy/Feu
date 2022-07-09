# Créez un programme qui remplace les caractères vides par des caractères plein pour représenter le plus grand carré possible sur un plateau.
# Le plateau sera transmis dans un fichier. La première ligne du fichier contient les informations pour lire la carte :
# nombre de lignes du plateau, caractères pour “vide”, “obstacle” et “plein”.

# Fonctions utilisées
def read_board(board)
  obstacles = []
  coordinates = []
  board.each_with_index do |line, li|
    line.each_with_index do |char, ci|
      coordinates << [li, ci]
      obstacles << [li, ci] if char == 'x'
    end
  end
  [coordinates, board.size, obstacles]
end

def find(board)
  coords = read_board(board)[0]
  board_size = read_board(board)[1]
  obstacles = read_board(board)[2]
  lines = []

  board_size.times do |index|
    lines << coords.filter { |coor| coor[0] == index }
  end
  squares = filter_squares(lines, board_size)
  squares.reject! { |square| square.include?(nil) }
  squares.select! { |square| square[0][1] == square[2][1] && square[1][1] == square[3][1] }
  squares.reject! { |square| square.uniq.size < 4 }

  obstacles.each do |obstacle|
    squares.reject! do |square|
      square.include?(obstacle)
    end
  end
  valid_squares = fill_squares(squares)
  obstacles.each do |obstacle|
    valid_squares.reject! do |square|
      square.include?(obstacle)
    end
  end
  valid_squares[0].each do |valid_coordinate|
    board[valid_coordinate[0]][valid_coordinate[1]] = 'o'
  end
  board.map(&:join)
end

def fill_squares(squares)
  squares.each do |square|
    x = square[0][1]
    y = square[0][0]
    missing_y_coordinates = all_between(*[y..square[2][0]], y, square[2][0])
    missing_y_coordinates.each do |c|
      cc = c.clone
      cc << x
      square << cc
      c << square[1][1]
      square << c
    end
    i = 0
    until square.size == (square[1][1] - x + 1)**2
      square_size = square.clone.size
      missing_x_coordinates = all_between(*[square[i][1]..square[i + 1][1]], square[i][1], square[i + 1][1])
      until square.size == square_size + (square[1][1] - x - 1)
        missing_x_coordinates.each do |c|
          c.prepend(square[i][0])
          square << c
        end
      end
      i += 2
    end
  end
end

def all_between(arr, lower, upper)
  arr.grep(lower.succ...upper).map { |n| n.digits.reverse }
end

def filter_squares(arr, board_size)
  res = []
  board_size -= 1
  board_size.downto(0) do |size|
    next if size.zero?

    arr.each_with_index do |coordinates, index|
      coordinates.each_with_index do |coordinate, ind|
        next if arr[index + size].nil?

        res << [coordinate, coordinates[ind + size], arr[index + size][ind], arr[index + size][ind + size]]
      end
    end
  end
  res
end

# Gestion d'erreurs
(puts "Erreur.\nVeuillez passer un plateau en argument."; exit) unless ARGV.size == 1
(puts "Erreur.\nLe fichier passé en argument ne peut être ouvert."; exit) unless File.file?(ARGV[0])

def board_error?(board)
  lines_size = []
  board.each { |line| lines_size << line.size }
  (puts "Erreur.\nLes lignes du plateau ne sont pas régulières."; exit) unless lines_size.uniq.size < 2

  (puts "Erreur.\nLe plateau est vide."; exit) unless lines_size.size.positive? && lines_size.all?(&:positive?)

  (puts "Erreur.\nLes lignes du plateau ne sont pas séparées en plusieurs lignes."; exit) unless board.size == File.read(ARGV[0]).split("\n").size
end

# Parsing
board = []
File.foreach(ARGV[0]) { |line| board << line.chomp.split('') }
File.foreach(ARGV[0]) { |line| board << line.chomp.split('') }
# Résolution
board_error?(board)
find_biggest_square = find(board)

# Affichage
puts find_biggest_square
