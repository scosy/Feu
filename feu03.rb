# frozen_string_literal: true

# Créez un programme qui trouve et affiche la solution d’un Sudoku.

# Fonctions utilisées
def valid?(unfinished_sudoku, row, column, possible_number)
  not_in_row = !unfinished_sudoku[row].include?(possible_number)
  not_in_column = []; (0..8).each { |i| not_in_column << unfinished_sudoku[i][column] }
  not_in_column = !not_in_column.include?(possible_number)
  not_in_box = []; (row / 3 * 3..row / 3 * 3 + 2).each { |i| (column / 3 * 3..column / 3 * 3 + 2).each { |j| not_in_box << unfinished_sudoku[i][j] } }
  not_in_box = !not_in_box.include?(possible_number)
  [not_in_row, not_in_column, not_in_box]
end

def solve(unfinished_sudoku, row = 0, column = 0)
  if row == 9
    true
  elsif column == 9
    solve(unfinished_sudoku, row += 1, 0)
  elsif unfinished_sudoku[row][column] != 0
    solve(unfinished_sudoku, row, column += 1)
  else
    (1..9).each do |possible_number|
      if valid?(unfinished_sudoku, row, column, possible_number)[0] &&
         valid?(unfinished_sudoku, row, column, possible_number)[1] &&
         valid?(unfinished_sudoku, row, column, possible_number)[2]
        unfinished_sudoku[row][column] = possible_number
        return unfinished_sudoku.map(&:join) if solve(unfinished_sudoku, row, column += 1)
()
        unfinished_sudoku[row][column] = 0
      end
    end
    false
  end
end

# Gestion d'erreurs
if ARGV.size != 1
  (puts 'error'
   exit)
end
unless File.file?(ARGV[0])
  (puts 'error'
   exit)
end
# Parsing
unfinished_sudoku = []
File.foreach(ARGV[0]) { |line| unfinished_sudoku << line.chomp.split('') }
unfinished_sudoku.each { |row| row.map! { |n| n == '.' ? 0 : n.to_i } }

# Résolution
sudoku_solver = solve(unfinished_sudoku)

# Affichage
puts sudoku_solver
