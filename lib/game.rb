class Game

    attr_reader :word, :word_status
    @@words = []

    def initialize

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
        @guesses_left = 10
        @correct_letters = []
        @incorrect_letters = []

    end

    def guess_letter?(letter)

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
            @guesses_left -= 1
        end

        return letter_found

    end

    def display_game_state()
        puts @word_status
        puts "Correct Guesses: #{@correct_letters.join(' ')}"
        puts "Incorrect Guesses: #{@incorrect_letters.join(' ')}"
        puts "You have #{@guesses_left} left"
    end
end