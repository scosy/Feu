# Créez un programme qui trouve et affiche la solution d’un Sudoku.

# Fonctions utilisées
def sudoku(unfinished_sudoku)
  
end
# Gestion d'erreurs
(puts "error"; exit ) if ARGV.size != 1
(puts "error"; exit ) if !File.file?(ARGV[0])

# Parsing
unfinished_sudoku = []
File.foreach(ARGV[0]) { |line| unfinished_sudoku << line.chomp.split('')}

# Résolution
sudoku_solver = sudoku(unfinished_sudoku)

# Affichage
puts sudoku_solver