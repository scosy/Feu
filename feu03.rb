# Créez un programme qui trouve et affiche la solution d’un Sudoku.

# Fonctions utilisées
def sudoku(unfinished_sudoku)
  unfinished_sudoku.each.with_index do |row, row_index|
    row.each.with_index do |number, number_index|
      if number == "."
        possible_numbers = find_possible_numbers(unfinished_sudoku, row_index, number_index)
        
        exit
      end
    end
  end
  unfinished_sudoku.map { |v| v.join }
end

def find_possible_numbers(unfinished_sudoku, row_index, number_index)
  range = [*1..9]
  range.map { |number| unfinished_sudoku[row_index].include?(number.to_s) ? () : number }.compact
end

def check_if_break_line(unfinished_sudoku, row_index, number_index, possible_numbers)
  possible_numbers.each
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