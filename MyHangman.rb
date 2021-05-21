require 'net/http'
class Hangman
    attr_accessor :chosen_word,:wordLength,:players_word,:used_letters,:chances,:temp_word

    def initialize(chances=8)
        @chosen_word = choose_word.upcase
        @wordLength = @chosen_word.length
        @players_word = ""
        @used_letters = ""
        @chances = chances
        @temp_word = ""
        for i in 0...@wordLength
            @players_word = @players_word + "_ "
        end
    end

    # method to start the game
    def start_game
      while !game_over?
          play_game
      end
        
      puts "Game Over"
      puts "The word was: #{@chosen_word}"
      if @chances > 0
          puts "You Won the game !!"
      else
          puts "Sorry, You lost the game"
      end
    end

    private
    #method to choose a word from array of words
    def choose_word
        uri = URI('https://random-word-api.herokuapp.com/word?number=5')
        words = Net::HTTP.get(uri)  
        words = words.delete("[").delete("]").delete("\"")
        words = words.split(",")
        index = rand(words.count - 1)
        return words[index]
    end

    def game_over?
        @temp_word = @players_word
        @temp_word = @temp_word.delete(" ")
        return @chances == 0 || @temp_word.eql?(@chosen_word) 
    end

    def play_game
        puts "Total chances left : #{@chances}" 
        puts "Your word : #{@players_word}"
        print "Enter a letter : " 
        letter = gets.chomp().upcase;
      
        #Check for invalid input (more than 1 letters)
        if (letter.length > 1) 
          puts "Invalid input" 
          play_game
        end
      
        # Check if  word contains the input letter
        if  @chosen_word.include? letter
          for i in 0...@wordLength
            if (@chosen_word[i] == letter) && (@players_word[i*2] == "_")
              @players_word[i*2] = letter 
            elsif @chosen_word[i] == letter
              puts "Input letter is already used"
              play_game  
            end
          end
        else 
          @chances -= 1
          @used_letters += letter.upcase.to_s + ","
        end
        puts "The incorrect letters entered are :#{@used_letters}"
      end
end

Hangman.new.start_game
