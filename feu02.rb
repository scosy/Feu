# Créez un programme qui affiche la position de l’élément
# le plus en haut à droite (dans l’ordre) d’une forme au sein d’un plateau.

# Fonctions utilisées

def find(board, to_find)
  # Stocke le nombre d'éléments à trouver
  count_to_find = 0
  to_find.each { |el| el.each { |sub_el| count_to_find += 1 if sub_el != ' ' } }

  # Retrouve toutes les coordonnées de chaque élément à trouver et les stocke dans le hash "coordinates", avec la key lycx ou l = ligne et c = colonne
  to_find_row_index = 0
  to_find_number_index = 0
  board_coordinates = Hash.new { |hash, key| hash[key] = [] }
  to_find_coordinates = Hash.new { |hash, key| hash[key] = [] }
  loop do
    board.each.with_index do |board_row, board_row_index|
      board_row.each.with_index do |board_number, board_number_index|
        number_to_find = to_find[to_find_row_index][to_find_number_index]
        if board_number == number_to_find
          to_find_coordinates["c#{to_find_number_index}l#{to_find_row_index}"] = [to_find_number_index, to_find_row_index]
          (board_coordinates["c#{to_find_number_index}l#{to_find_row_index}"] << [board_number_index, board_row_index])
        end
      end
    end
    to_find_number_index += 1
    unless to_find[to_find_number_index]
      to_find_row_index += 1
      to_find_number_index = 0
    end
    break unless to_find[to_find_row_index]
  end

  # board_coordinates.each { |k, v| return "Introuvable" if v.empty? }

  # Compare les index de to_find et de nos coordonnées pour retrouver le même écart entre les éléments
  coordinates = Hash.new { |hash, key| hash[key] = [] }
  i = 0
  loop do
    (0..board_coordinates['c0l0'].size - 1).each do |j|
      x_reference = board_coordinates['c0l0'][j][0]
      y_reference = board_coordinates['c0l0'][j][1]
      board_coordinates.each.with_index do |(key, line), index|
        next if index.zero?

        line.each do |coordinate|
          if coordinate[0] - key[1].to_i == x_reference && coordinate[1] - key[3].to_i == y_reference && !coordinates["#{x_reference}, #{y_reference}"].include?(coordinate)
            coordinates["#{x_reference}, #{y_reference}"] << coordinate
          end
        end
      end
    end

    break if i == board_coordinates.size - 1

    i += 1
  end

  # Filtre les coordonnées restantes en comparant au nombre d'éléments à trouver
  return 'Introuvable' unless coordinates.values.any? { |value| value.size + 1 == count_to_find }

  coordinates.delete_if { |_key, el| el.size + 1 != count_to_find }
  y = []
  x = []
  coordinates.each_key do |key|
    x << key.match(/^[^,]*/).to_s.to_i
    y << key.match(/(?<=,).*/).to_s.to_i
  end
  final_coordinates = coordinates.keys.select { |key| key[3..5].to_i == y.min && key[0..2].to_i == x.max }[0]
  puts 'Trouvé !'
  puts "Coordonnées: #{final_coordinates}"

  # Retourne le tableau modifié
  new_board = board.map do |line|
    line.map { |_char| ' ' }
  end
  new_board[final_coordinates[3..5].to_i][final_coordinates[0..2].to_i] = board[final_coordinates[3..5].to_i][final_coordinates[0..2].to_i]
  coordinates[final_coordinates].each do |coordinate|
    new_board[coordinate[1]][coordinate[0]] = board[coordinate[1]][coordinate[0]]
  end
  new_board.map(&:join)
end

# Gestion d'erreurs
(puts 'error'; exit) if ARGV.size != 2
(puts 'error'; exit) unless File.file?(ARGV[0]) && File.file?(ARGV[1])

# Parsing
board = []
to_find = []
File.foreach(ARGV[0]) { |line| board << line.chomp.split('') }
File.foreach(ARGV[1]) { |line| to_find << line.chomp.split('') }

# Résolution
find_shape = find(board, to_find)

# Affichage
puts find_shape
