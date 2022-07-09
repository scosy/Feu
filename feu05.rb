# Créez un programme qui trouve le plus court chemin entre l’entrée et la sortie d’un labyrinthe en évitant les obstacles.

# Le labyrinthe est transmis en argument du programme.
# La première ligne du labyrinthe contient les informations pour lire la carte :
# LIGNESxCOLS, caractère plein, vide, chemin, entrée et sortie du labyrinthe.

# Le but du programme est de remplacer les caractères “vide” par des caractères “chemin”
# pour représenter le plus court chemin pour traverser le labyrinthe.
# Un déplacement ne peut se faire que vers le haut, le bas, la droite ou la gauche.

# Fonctions utilisées
def find_shortest_path(labyrinth, infos)
  obstacles = isolate_obstacles(labyrinth, infos)[0]
  obstacleless_labyrinth = isolate_obstacles(labyrinth, infos)[1]
  entrance = [0, labyrinth[0].index(infos[8])]
  labyrinth_exit = [labyrinth.index(labyrinth[-1]), labyrinth[-1].index(infos[9])]
  path = []

  obstacleless_labyrinth.each_with_index do |line, index|
    loop do
      line.each_with_index do |_char, line_index|
        next unless index == entrance[0] && line_index == entrance[1]

        if path.empty?
          path << [index + 1, line_index - obstacles.count { |coordinate| coordinate[0] == index }]
        elsif path.size < obstacleless_labyrinth.size - 2
          path << [path.last[0] + 1, path.last[1]]
        elsif path.last[1] < labyrinth_exit[1]
          path << [path.last[0], path.last[1] + 1]
        elsif path.last[1] > labyrinth_exit[1]
          path << [path.last[0], path.last[1] - 1]
        end
      end
      break if path.include?([labyrinth_exit[0] - 1, labyrinth_exit[1]])
    end
  end

  p path, obstacles
  path.each do |coordinate|
    obstacleless_labyrinth[coordinate[0]][coordinate[1]] = infos[7]
  end
  obstacles.each do |coordinate|
    obstacleless_labyrinth[coordinate[0]].insert(coordinate[1], infos[5])
  end
  obstacleless_labyrinth.map(&:join)
end

def isolate_obstacles(array, infos)
  obstacles = []
  array[1..-2].each_with_index do |line, arr_index|
    line.each_with_index do |char, line_index|
      next unless char == infos[5] && (line_index.positive? && line_index < line.size - 1)

      obstacles << [arr_index + 1, line_index]
      array[arr_index + 1][line_index] = nil
    end
  end
  [obstacles, array]
end

# Gestion d'erreurs
(puts 'error'; exit) if ARGV.size != 1

# Parsing
labyrinth = []
File.foreach(ARGV[0]) { |line| labyrinth << line.chomp.split('') }
infos = labyrinth.shift

# Résolution
shortest_path = find_shortest_path(labyrinth, infos)

# Affichage
puts shortest_path
