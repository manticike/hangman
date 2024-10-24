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