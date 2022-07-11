# Créez un programme qui trouve le plus court chemin entre l’entrée et la sortie d’un labyrinthe en évitant les obstacles.

# Le labyrinthe est transmis en argument du programme.
# La première ligne du labyrinthe contient les informations pour lire la carte :
# LIGNESxCOLS, caractère plein, vide, chemin, entrée et sortie du labyrinthe.

# Le but du programme est de remplacer les caractères “vide” par des caractères “chemin”
# pour représenter le plus court chemin pour traverser le labyrinthe.
# Un déplacement ne peut se faire que vers le haut, le bas, la droite ou la gauche.

# Fonctions utilisées
def find_shortest_path(labyrinth, infos)
  @infos = infos
  @labyrinth = labyrinth
  @visited = labyrinth.map { |line| line.map { |char| char } }
  @entrance = [0, labyrinth[0].index(infos[8])]
  @labyrinth_exit = [labyrinth.index(labyrinth[-1]), labyrinth[-1].index(infos[9])]

  @shortest_length = labyrinth.size * labyrinth[0].size
  @length = 0
  @has_path = false
  @iterator = 0

  def find_path
    visit(@entrance[0], @entrance[1])
  end

  def visit(x, y)
    if x == @labyrinth_exit[0] && y == @labyrinth_exit[1]
      @has_path = true
      @shortest_length = [@length, @shortest_length].min
    end
    return if @has_path

    return if @iterator > 1000

    @visited[x][y] = @infos[7] unless @entrance == [x, y] && @has_path == false
    @length += 1

    sum = 0
    line_sum = 0
    @visited.each do |arr|
      sum += line_sum
      line_sum = 0
      arr.each { |char| line_sum += 1 if char == 'o' }
    end
    @labyrinth = @visited.map(&:join) if sum + 1 == @length

    visit(x + 1, y) if can_visit(x + 1, y)
    visit(x, y + 1) if can_visit(x, y + 1)
    visit(x, y - 1) if can_visit(x, y - 1)
    visit(x - 1, y) if can_visit(x - 1, y)

    @visited[x][y] = @infos[6] unless @entrance == [x, y]
    @length -= 1
    @iterator += 1
  end

  def can_visit(x, y)
    if x.negative? || y.negative? || x >= @labyrinth[0].size || y >= @labyrinth.size
      false
    elsif @labyrinth[x][y] == @infos[5] || @visited[x][y] == @infos[7]
      false
    else
      true
    end
  end

  find_path
  puts @infos.join, @labyrinth if @has_path
  @has_path ? "Sortie atteinte en #{@shortest_length} coups" : 'Impossible'
end

# Parsing
labyrinth = []
File.foreach(ARGV[0]) { |line| labyrinth << line.chomp.split('') }
infos = labyrinth.shift

# Gestion d'erreurs
(puts 'error'; exit) if ARGV.size != 1
(puts 'error'; exit) unless infos.join.start_with?(/^\d{1,2}x\d{1,2}/)

# Résolution
shortest_path = find_shortest_path(labyrinth, infos)

# Affichage
puts shortest_path
