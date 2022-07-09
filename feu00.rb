# Créez un programme qui affiche un rectangle dans le terminal.

# Fonctions utilisées
def are_numeric_and_positive(num1, num2)
  num1.positive? && num2.positive?
end

def shape(horizontal, vertical)
  array = []
  vertical.times { |columns| array[columns] = [] }
  # Je remplis la première et dernière ligne de mon tableau
  (horizontal - 1).downto(0) do |j|
    if j.zero? || j == horizontal - 1
      array[0][j] = 'o'
      array[-1][j] = 'o'
    else
      array[0][j] = '-'
      array[-1][j] = '-'
    end
  end
  # Je remplis les lignes restantes
  array.each do |row|
    next unless row.empty?

    (0..horizontal - 1).each do |i|
      i.zero? || i == horizontal - 1 ? (row[i] = '|') : (row[i] = ' ')
    end
  end

  array.map(&:join)
end

# Gestion d'erreurs
(puts 'error'; exit) if ARGV.size != 2
(puts 'error'; exit) unless are_numeric_and_positive(ARGV[0].to_i, ARGV[1].to_i)

# Parsing
horizontal = ARGV[0].to_i
vertical = ARGV[1].to_i

# Résolution
rectangle = shape(horizontal, vertical)

# Affichage
puts rectangle
