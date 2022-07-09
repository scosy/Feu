# Créez un programme qui reçoit une expression arithmétique dans une chaîne de caractères
# et en retourne le résultat après l’avoir calculé.
# Vous devez gérer les 5 opérateurs suivants : “+” pour l’addition, “-” pour la soustraction,
# “*” la multiplication, “/” la division et “%” le modulo.

# Fonctions utlisées

# Transforme l'expression en expression 'postfix' pour la traiter
# selon l'algorithme de Shunting-Yard. (https://en.wikipedia.org/wiki/Shunting-yard_algorithm)
def to_postfix(array)
  output = []
  operators = []
  until array.empty?
    array.each do
      if array[0].match?(/\d/)
        output << array.shift
      elsif array[0].match?(%r{[*/%+-]})
        output << operators.pop while (operators.last != '(') && (['*', '/', '%'].include?(operators.last) || array[0] == operators.last)
        operators << array.shift
      elsif array[0] == '('
        operators << array.shift
      elsif array[0] == ')'
        array.shift
        output << operators.pop while operators.last != '('
        operators.pop
      end
    end
  end
  output << operators.pop until operators.empty?
  [output, operators]
end

# Évalue l'expression postfix
def eval(array)
  output = array[0]
  values = array[1]
  until output.empty?
    if output[0].match?(/\d/)
      values << output.shift
    elsif output[0].match?(%r{[*/%+-]})
      operands = values.pop(2)
      values << (operands[0].to_i).method(output.shift).call(operands[1].to_i)
    end
  end
  values.join.to_i
end

# Parsing
array = ARGV[0].split(/\s+/)
array.map! do |e|
  if e[0] == '(' && e.size > 1
    array.insert(array.index(e), e.slice!(/\(/))
    '('
  elsif e[-1] == ')' && e.size > 1
    array.insert(array.index(e) + 1, e.slice!(/\)/))
    e
  else
    e
  end
end

# Résolution
evaluate_expression = eval(to_postfix(array))

# Affichage
p evaluate_expression
