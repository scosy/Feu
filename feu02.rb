# Créez un programme qui affiche la position de l’élément
# le plus en haut à droite (dans l’ordre) d’une forme au sein d’un plateau.

# Fonctions utilisées
def find(board, to_find)
  indexes_to_find = {}
  to_find.each.with_index { |e, ind| (indexes_to_find["l #{ind}"] = e.index(/\d/)) }
  to_find.map! { |e| e.delete(" ") }
  # Nombre d'éléments correspondants à to_find trouvés
  found = 0
  # Stocker index des lignes trouvées
  lines_found = []
  # Stocker index des colonnes trouvées
  columns_found = {}
  # Récupérer les index des éléments à trouver
  board.each.with_index do |r, i|
    to_find.each.with_index do |ro, ind|
      if r.match?(/#{ro}/) && !lines_found.include?(i)
        lines_found << i
        columns_found["l #{i}"] = (0..r.length).find_all { |i| r[i, ro.size] === ro }
        found += 1
      end
    end
  end

  # Comparer la différence entre les indexs des lignes à trouver et celles trouvées
  # pour vérifier que c'est bien la forme qu'on recherche
  (to_find.size - 1).downto(0) do |i|
    @rtf = indexes_to_find.values[i] - indexes_to_find.values[i - 1]
    break if i === 1
  end
  x = 0
  while (columns_found.values.last.last - x) != @rtf
    x += 1
  end
  y = lines_found.first

  (found >= to_find.size) ? (puts "Trouvé !") : (puts "Introuvable :(")

  puts "Coordonnées: #{x}, #{y}"
  # draw(board, to_find, columns_found, lines_found, x, y)
end

# def draw(board, to_find, columns_found, lines_found, x ,y)
#   for i in 0..board.size - 1
#     (board[i] = "-" * board[i].size; next) if !lines_found.include?(i)

#     (i === lines_found[0]) ? (o = x) :  (o = columns_found["l #{i}"].last)
#     (to_find.size === board.size) ? (r = to_find[i]) : (r = to_find[i - 1])
#     # v = board[i].slice!(o..o + to_find[i - 1].size - 1)
#     # board[i] = "-" * board[i].size
#     # board[i].insert(o, v) unless  !v
#     board[i] = "-" * (board[i].size - r.size)
#     board[i].insert(o, r)
#   end
#   board

  
# end

# Gestion d'erreurs
(puts "error"; exit ) if ARGV.size != 2
(puts "error"; exit ) if !(File.file?(ARGV[0]) && File.file?(ARGV[1]))


# Parsing
board = []
to_find = []
File.foreach(ARGV[0]) { |line| board << line.chomp}
File.foreach(ARGV[1]) { |line| to_find << line.chomp}

# Résolution
find_shape = find(board, to_find)

# Affichage
puts find_shape 