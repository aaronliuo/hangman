require_relative 'game.rb'

def play_game()
    game = Game.new()
    while !game.game_end
        game.display_game_state()
        game.game_actions()
        game.check_win()
    end
end

while true
    puts "Welcome to Hangman! Press 'y' to play and 'n' to quit."
    response = gets.chomp.downcase
    until response.match?('^y$|^n$')
        puts "Invalid response"
        puts "Press 'y' to play and 'n' to quit."
        response = gets.chomp.downcase
    end
    if response == 'y'
        play_game()
    else
        break
    end
end

