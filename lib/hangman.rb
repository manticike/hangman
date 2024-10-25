def random_word_from_file(file_name)
  # Read the words in the file line by line
  words = File.readlines(file_name)

  # An array to store the selected words
  selected_words = []

  words.each do |line|
    selected_words += line.split.select { |word| word.length.between?(5, 12) }
  end
  # Randomly select a word between 5 and 12 characters
  selected_words.sample
end

def play_hangman
  word = random_word_from_file('dictionary.txt').upcase
  puts "The proper secret word is: #{word}"
  max_incorrect_guesses = 6
  incorrect_guesses = []
  correct_guesses = []
  displayed_word = '_' * word.length

  puts "You have #{max_incorrect_guesses} tries"

  while incorrect_guesses.length < max_incorrect_guesses
    puts "Word: #{displayed_word}"
    puts "Incorrect guesses: #{incorrect_guesses.join(', ')} "
    puts "Correct guesses: #{correct_guesses.join(', ')}"

    # Prompt the user for a letter
    print 'Guess a letter: '
    guess = gets.chomp.upcase

    # Validate input
    if guess.length != 1 || !('A'..'Z').include?(guess)
      puts 'Please enter a single letter.'
      next
    end

    # Check if the guessed letter has already been guessed
    if incorrect_guesses.include?(guess) || correct_guesses.include?(guess)
      puts "You've already guessed that letter. Try again."
      next
    end

    # Check if the guessed letter is in the word
    if word.include?(guess)
      # Update displayed_word with the guessed letter
      word.chars.each_with_index do |char, index|
        if char == guess
          displayed_word[index] = guess
        end
      end
      correct_guesses << guess unless correct_guesses.include?(guess)

    else
      incorrect_guesses << guess unless incorrect_guesses.include?(guess)
    end

    # Check for win condition
    unless displayed_word.include?('_')
      puts "Congratulations! You've guessed the word: #{word}"
      return
    end
  end

  puts "Game Over! The word was: #{word}"
end

play_hangman
