# Créez un programme qui affiche la position de l’élément
# le plus en haut à droite (dans l’ordre) d’une forme au sein d’un plateau.

# Fonctions utilisées

def find(board, to_find)
  #Stocke le nombre d'éléments à trouver
  count_to_find = 0
  to_find.each { |el| el.each{ |sub_el| count_to_find += 1 if sub_el != " " }}

  # Retrouve toutes les coordonnées de chaque élément à trouver et les stocke dans le hash "coordinates", avec la key lycx ou l = ligne et c = colonne
  to_find_row_index = 0
  to_find_number_index = 0
  board_coordinates = Hash.new {|hash, key| hash[key] = Array.new }
  to_find_coordinates = Hash.new {|hash, key| hash[key] = Array.new }
  loop do
    board.each.with_index do |board_row, board_row_index|
      board_row.each.with_index do |board_number, board_number_index|
        number_to_find = to_find[to_find_row_index][to_find_number_index]
        if board_number === number_to_find
          to_find_coordinates["c#{to_find_number_index}l#{to_find_row_index}"] = [to_find_number_index, to_find_row_index]
          (board_coordinates["c#{to_find_number_index}l#{to_find_row_index}"] << [board_number_index, board_row_index])
        end
      end
    end
    to_find_number_index += 1
    if !to_find[to_find_number_index]
      to_find_row_index += 1
      to_find_number_index = 0
    end
    if !to_find[to_find_row_index]
      break
    end
  end

  # board_coordinates.each { |k, v| return "Introuvable" if v.empty? }

  # Compare les index de to_find et de nos coordonnées pour retrouver le même écart entre les éléments
  coordinates = Hash.new {|hash, key| hash[key] = Array.new }
  i = 0
  loop do
    for j in 0..board_coordinates["c0l0"].size - 1
      x_reference = board_coordinates["c0l0"][j][0]
      y_reference = board_coordinates["c0l0"][j][1]
      board_coordinates.each.with_index do |(key, line), index|
        next if index == 0
        line.each do |coordinate|
          if (coordinate[0] - key[1].to_i == x_reference && coordinate[1] - key[3].to_i == y_reference)
            coordinates["#{x_reference}, #{y_reference}"] << coordinate if !coordinates["#{x_reference}, #{y_reference}"].include?(coordinate)
          end
        end
      end

    end

      break if i == board_coordinates.size - 1
      i += 1
  end

# Filtre les coordonnées restantes en comparant au nombre d'éléments à trouver
  if coordinates.values.any? {|value| value.size + 1 == count_to_find}
    coordinates.delete_if { |key, el| el.size + 1 != count_to_find}
  else
    return "Introuvable"
  end
  y = []
  x = []
  coordinates.keys.each { |key| x << key.match(/^[^,]*/).to_s.to_i; y << key.match(/(?<=\,).*/).to_s.to_i }
  final_coordinates =coordinates.keys.select { |key| key[3..5].to_i == y.min && key[0..2].to_i == x.max }[0]
  puts "Trouvé !"
  puts "Coordonnées: #{final_coordinates}"

  # Retourne le tableau modifié
  new_board = board.map do |line|
    line.map { |char| " " }
  end
  new_board[final_coordinates[3..5].to_i][final_coordinates[0..2].to_i] = board[final_coordinates[3..5].to_i][final_coordinates[0..2].to_i]
  coordinates[final_coordinates].each do |coordinate|
    new_board[coordinate[1]][coordinate[0]] = board[coordinate[1]][coordinate[0]]
  end
  new_board.map { |line| line.join }
end

# Gestion d'erreurs
(puts "error"; exit ) if ARGV.size != 2
(puts "error"; exit ) if !(File.file?(ARGV[0]) && File.file?(ARGV[1]))


# Parsing
board = []
to_find = []
File.foreach(ARGV[0]) { |line| board << line.chomp.split('')}
File.foreach(ARGV[1]) { |line| to_find << line.chomp.split('')}

# Résolution
find_shape = find(board, to_find)

# Affichage
puts find_shape 


# def find(board, to_find)
#   coordinates = []
#   number_to_find = nil
#   tfrow_index = 0
#   tfnumber_index = 0
#   all_true = 0
#   board.each.with_index do |brow, brow_index|
#     brow.each.with_index do |bnumber, bnumber_index|
#       number_to_find = to_find[tfrow_index][tfnumber_index]
#       if bnumber === number_to_find
#         if ((brow.size - 1 - bnumber_index) > 0)
#           to_find.size < 2 ? (coordinates << [bnumber_index, brow_index]) : ()
#           (to_find.size).times do |i|
#             if check_line(board, to_find, tfrow_index + i, brow_index + i, bnumber_index, tfnumber_index)
#               all_true += 1
#             else
#               all_true = 0
#             end
#             (all_true === to_find.size) ? (coordinates << [bnumber_index, brow_index]; all_true = 0) : ()
#           end
#         end
#       end
#     end
#   end
#   if coordinates.empty?
#     return "Introuvable"
#   else
#     print "Trouvé !\nCoordonnées: "
#     if coordinates.size > 1
#       result = coordinates.select { |e| e[0] === (coordinates.map { |el| el[0] }.max) }.select { |f| f[1] === (coordinates.map { |fl| fl[1] }.min)}.join(",")
#       puts result
#     else
#       result = coordinates.join(",")
#       puts result
#     end
#   end
#   new_board = []
#   board.each { |e|new_board << e.join }
#   new_board.map! { |e| e.each_char.with_index { |c, i| e[i] = '-' }}
#   for x in result[0].to_i..to_find.size + result[0].to_i - 1
#     for y in result[2].to_i..to_find[x - result[0].to_i].size + result[2].to_i - 1
#       next if to_find[y - result[2].to_i][x - result[0].to_i] === " "
#       new_board[y][x] = board[y][x]
#     end
#   end
#   new_board
# end


# def check_line(board, to_find, tfrow_index, brow_index, bnumber_index, tfnumber_index)
#   line_match = false
#   coordinates = []
#   for i in 0..to_find[tfrow_index].size - 1
#     # Si les éléments suivants, à partir de la première correspondance, correspondent à la ligne de to_find
#     if board[brow_index][bnumber_index + i] === to_find[tfrow_index][tfnumber_index + i]
#       coordinates << [bnumber_index + i, brow_index]
#       line_match = true
#     else
#       next if to_find[tfrow_index][tfnumber_index + i] === " "
#       line_match = false
#       break
#     end
#   end
#   return line_match
# end