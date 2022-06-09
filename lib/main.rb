require_relative 'game.rb'

game = Game.new()
puts game.display_game_state()
print "Guess a letter: "
letter = gets.chomp.downcase()
until letter.match?("^[a-z]$")
    puts "Invalid input"
    print "Guess a letter: "
    letter = gets.chomp.downcase()
end
puts game.guess_letter?(letter)
puts game.display_game_state()
