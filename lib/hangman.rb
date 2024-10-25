require 'json'

def random_word_from_file(file_name)
  words = File.readlines(file_name)
  selected_words = words.flat_map { |line| line.split.select { |word| word.length.between?(5, 12) } }
  selected_words.sample
end

def save_game_state(file_name, state)
  File.open(file_name, 'w') do |file|
    file.write(JSON.dump(state))
  end
end

def load_game_state(file_name)
  if File.exist?(file_name)
    JSON.parse(File.read(file_name))
  else
    nil
  end
end

def play_hangman
  state_file = 'game_state.json'
  state = load_game_state(state_file)

  if state
    # Load saved state
    word = state['word']
    max_incorrect_guesses = state['max_incorrect_guesses']
    incorrect_guesses = state['incorrect_guesses']
    correct_guesses = state['correct_guesses']
    displayed_word = state['displayed_word']
    puts 'Resuming your saved game...'
  else
    # Start a new game
    word = random_word_from_file('dictionary.txt').upcase
    max_incorrect_guesses = 6
    incorrect_guesses = []
    correct_guesses = []
    displayed_word = '_' * word.length
    puts 'Starting a new game!'
  end

  puts "You have #{max_incorrect_guesses} tries"

  while incorrect_guesses.length < max_incorrect_guesses
    puts "Word: #{displayed_word}"
    puts "Incorrect guesses: #{incorrect_guesses.join(', ')}"
    puts "Correct guesses: #{correct_guesses.join(', ')}"

    print 'Guess a letter (or type "save" to save the game): '
    guess = gets.chomp.upcase

    if guess == 'SAVE'
      # Save the game state
      save_game_state(state_file, {
        word: word,
        max_incorrect_guesses: max_incorrect_guesses,
        incorrect_guesses: incorrect_guesses,
        correct_guesses: correct_guesses,
        displayed_word: displayed_word
      })
      puts 'Game saved! You can continue later.'
      return
    end

    if guess.length != 1 || !('A'..'Z').include?(guess)
      puts 'Please enter a single letter.'
      next
    end

    if incorrect_guesses.include?(guess) || correct_guesses.include?(guess)
      puts "You've already guessed that letter. Try again."
      next
    end

    if word.include?(guess)
      word.chars.each_with_index { |char, index| displayed_word[index] = guess if char == guess }
      correct_guesses << guess
    else
      incorrect_guesses << guess
    end

    unless displayed_word.include?('_')
      puts "Congratulations! You've guessed the word: #{word}"
      File.delete(state_file) if File.exist?(state_file)
      return
    end
  end

  puts "Game Over! The word was: #{word}"
  File.delete(state_file) if File.exist?(state_file)
end

play_hangman