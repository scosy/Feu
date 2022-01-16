# Créez un programme qui affiche un rectangle dans le terminal.

# Fonctions utilisées
def are_numeric_and_positive(n1, n2)
  n1 > 0 && n2 > 0
end

def shape(horizontal, vertical)
  array = []
  vertical.times { |columns| array[columns] = []}
  # Je remplis la première et dernière ligne de mon tableau
  (horizontal - 1).downto(0) do |j|
    (j === 0 || j === horizontal - 1) ? (array[0][j], array[-1][j] = "o", "o") : (array[0][j], array[-1][j] = "-", "-")
  end
# Je remplis les lignes restantes
  array.each { |row| if row.empty?
    for i in 0..horizontal - 1 
      (i === 0 || i === horizontal - 1) ? (row[i] = "|") : (row[i] = " ")
    end
  end
  }

  array.map! { |row| row.join }
end

# Gestion d'erreurs
(puts "error"; exit) if ARGV.size != 2
(puts "error"; exit) if !are_numeric_and_positive(ARGV[0].to_i, ARGV[1].to_i)

# Parsing
horizontal = ARGV[0].to_i
vertical = ARGV[1].to_i

# Résolution
rectangle = shape(horizontal, vertical)

# Affichage
puts rectangle