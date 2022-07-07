# Créez un programme qui remplace les caractères vides par des caractères plein pour représenter le plus grand carré possible sur un plateau.
# Le plateau sera transmis dans un fichier. La première ligne du fichier contient les informations pour lire la carte :
# nombre de lignes du plateau, caractères pour “vide”, “obstacle” et “plein”.

# Fonctions utilisées
def read_board(board)
  coordinates = []
  board.each_with_index { |line, li| line.each_with_index { |char, ci| coordinates << [li, ci] unless char != '.' } }
  [coordinates, board.size]
end

def find(board)
  coords = read_board(board)[0]
  board_size = read_board(board)[1]
  lines = []
  board_size.times do |index|
    lines << coords.filter { |coor| coor[0] == index }
  end
  squares = filter_squares(lines, board_size)
  # board.map(&:join)
  squares.reject! { |square| square.include?(nil) }
  squares.select! { |square| square[0][1] == square[2][1] }
  squares.reject! { |square| square.uniq.size < 4 }
end

def filter_squares(arr, size)
  res = []
  arr.each_with_index do |coordinates, index|
    coordinates.each_with_index do |coordinate, ind|
      a = []
      a << coordinate
      a << coordinates[ind + size - 1]
      a << arr[index + size - 1][ind]
      a << arr[index + size - 1][ind + size - 1]
      res << a
    end
    size -= 1
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
# Résolution
board_error?(board)
find_biggest_square = find(board)

# Affichage
p find_biggest_square
