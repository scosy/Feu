# Créez un programme qui affiche la position de l’élément
# le plus en haut à droite (dans l’ordre) d’une forme au sein d’un plateau.

# Fonctions utilisées
def find(board, to_find)
  coordinates = []
  number_to_find = nil
  tfrow_index = 0
  tfnumber_index = 0
  all_true = 0
  board.each.with_index do |brow, brow_index|
    brow.each.with_index do |bnumber, bnumber_index|
      number_to_find = to_find[tfrow_index][tfnumber_index]
      if bnumber === number_to_find
        if ((brow.size - 1 - bnumber_index) > 0)
          to_find.size < 2 ? (coordinates << [bnumber_index, brow_index]) : ()
          (to_find.size).times do |i|
            if check_line(board, to_find, tfrow_index + i, brow_index + i, bnumber_index, tfnumber_index)
              all_true += 1
            else
              all_true = 0
            end
            # p all_true
            (all_true === to_find.size) ? (coordinates << [bnumber_index, brow_index]; all_true = 0) : ()
          end
        end
      end
    end
  end
  if coordinates.empty?
    return "Introuvable"
  else
    print "Trouvé !\nCoordonnées: "
    if coordinates.size > 1
      result = coordinates.select { |e| e[0] === (coordinates.map { |el| el[0] }.max) }.select { |f| f[1] === (coordinates.map { |fl| fl[1] }.min)}.join(",")
      puts result
    else
      result = coordinates.join(",")
      puts result
    end
  end
  new_board = []
  board.each { |e|new_board << e.join }
  new_board.map! { |e| e.each_char.with_index { |c, i| e[i] = '-' }}
  for x in result[0].to_i..to_find.size + result[0].to_i - 1
    for y in result[2].to_i..to_find[x - result[0].to_i].size + result[2].to_i - 1
      next if to_find[y - result[2].to_i][x - result[0].to_i] === " "
      puts y,x
      new_board[y][x] = board[y][x]
    end
  end
  new_board
end


def check_line(board, to_find, tfrow_index, brow_index, bnumber_index, tfnumber_index)
  line_match = false
  coordinates = []
  for i in 0..to_find[tfrow_index].size - 1
    # p [board[brow_index][bnumber_index + i],to_find[tfrow_index][tfnumber_index + i]]
    # Si les éléments suivants, à partir de la première correspondance, correspondent à la ligne de to_find
    if board[brow_index][bnumber_index + i] === to_find[tfrow_index][tfnumber_index + i]
      coordinates << [bnumber_index + i, brow_index]
      line_match = true 
    else
      next if to_find[tfrow_index][tfnumber_index + i] === " "
      line_match = false
      break
    end
  end
  return line_match
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