require 'json'

class Game

    attr_reader :game_end

    @@words = []
    @@MAX_GUESSES = 10

    def initialize()

        if @@words.length == 0
            word_array = File.readlines('google-10000-english-no-swears.txt')
            word_array.each do |word|
                word = word.chomp
                if word.length >= 5 && word.length <= 12
                    @@words << word
                end
            end
        end

        random_idx = rand(0...@@words.length)

        @word = @@words[random_idx]
        @word_status = "_" * @word.length
        @correct_letters = []
        @incorrect_letters = []
        @game_end = false
    end

    def save_game()
        print "Enter the game name you will save as (case-sensitive): "
        username = gets.chomp
        filename = "saved/#{username}.json"
        while username.match?(' |/')
            puts "Invalid file name. Please type in a different game name."
            username = gets.chomp
            filename = "saved/#{username}.json"
        end
        saved_game = JSON.dump({
            username: username,
            word: @word,
            word_status: @word_status,
            correct_letters: @correct_letters,
            incorrect_letters: @incorrect_letters
        })
        filename = "saved/#{username}.json"
        file = File.open(filename, 'w')
        file.puts saved_game
        file.close()
        puts "Your game has been saved under: #{username}"
    end

    def load_game()
        usernames = Dir["saved/*"]
        usernames = usernames.map { |user| user.slice(6...-5) }
        puts "These are the currently saved usernames"
        usernames.each { |user| puts user }
        puts "Enter the username you saved your game as (case-sensitive)."
        username = gets.chomp
        filename = "saved/#{username}.json"
        until File.exist?(filename)
            puts "Invalid username"
            puts "Enter the username you saved your game as."
            username = gets.chomp
            filename = "saved/#{username}.json"
        end

        data = JSON.load File.read(filename)
        puts data
        @word = data['word']
        @word_status = data['word_status']
        @correct_letters = data['correct_letters']
        @incorrect_letters = data['incorrect_letters']
        puts "Loaded #{data['username']}'s game"
    end

    def check_win()

        if @@MAX_GUESSES-@incorrect_letters.length <= 0
            #game loss
            puts "You have lost the game"
            puts "The word was '#{@word}'"
            @game_end = true
        end

        for i in 0...@word.length
            if @word_status[i] == '_'
                #game continues
                return
            end
        end

        #game won
        puts "You have won the game"
        puts "The word was '#{@word}'"
        @game_end = true

    end

    def guess_letter(letter)

        letter_found = false

        for i in 0...@word.length
            if @word[i] == letter
                @word_status[i] = letter
                letter_found = true
            end
        end

        if letter_found
            @correct_letters.push(letter)
        else
            @incorrect_letters.push(letter)
        end

        return letter_found

    end

    def display_game_state()
        puts @word_status
        puts "Correct Guesses: #{@correct_letters.join(' ')}"
        puts "Incorrect Guesses: #{@incorrect_letters.join(' ')}"
        puts "You have #{@@MAX_GUESSES-@incorrect_letters.length} guesses left\n\n"
    end

    def game_actions()
        puts "Enter one of the following: "
        puts "  'Save' to save the game"
        puts "  'Load' to load a previously saved game"
        puts "  'Quit' to quit the game"
        puts "  Any letter between 'a-z' to guess that letter"
        response = gets.chomp.downcase()
        until response.match?('^save$|^load$|^quit$|^[a-z]$')
            puts "Invalid response"
            puts "Enter a valid response from the options above"
            response = gets.chomp.downcase
        end
        if response == 'save'
            save_game()
        elsif response == 'load'
            load_game()
        elsif response == 'quit'
            @game_end = true
        else
            guess_letter(response)
        end
    end
end