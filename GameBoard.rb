class GameBoard
  attr_accessor :board, :playing
  attr_reader :interface_object

  def initialize(interface)
    @board = [%w[- - -], %w[- - -], %w[- - -]]
    @interface_object = interface
  end

  public

  def play(player)
    good_input = false
    until good_input
      spot = get_spot
      if board[spot[0]][spot[1]] == "-"
        good_input = true
        board[spot[0]][spot[1]] = player.sign
        interface_object.change_current_player
        if check_for_win(player)
          self.win_event(player)
        end
      else
        puts "That tile is already occupied!"
      end
    end
  end

  def display(player1, player2)
    interface_object.clear_console
    turn_mark = ""
    puts "#{player1.name}: #{player1.sign} #{  turn_mark if interface_object.current_player == player1 } \t\tPoints: #{player1.points}"
    puts "#{player2.name}: #{player2.sign} #{  turn_mark if interface_object.current_player == player2 } \t\tPoints: #{player2.points}"
    puts "\n"
    puts "\t #{board[0][0]} | #{board[0][1]} | #{board[0][2]}"
    puts "\t---|---|---"
    puts "\t #{board[1][0]} | #{board[1][1]} | #{board[1][2]}"
    puts "\t---|---|---"
    puts "\t #{board[2][0]} | #{board[2][1]} | #{board[2][2]}"
    puts "\n"
    puts "#{interface_object.current_player.name}'s turn!"
    puts "Please select a tile to play typing first the row number, then the column number"
    puts "For example: 32"
  end

  protected

  def get_spot
    begin
      user_input = gets.chomp
      unless (user_input == '11' or user_input == '12' or user_input == '13') \
           or (user_input == '21' or user_input == '22' or user_input == '23') \
           or (user_input == '31' or user_input == '32' or user_input == '33')
        raise "Invalid Input. Please try again!"
      end
    rescue StandardError => e
      puts "\n#{e}"
      retry
    end
    [user_input[0].to_i - 1, user_input[1].to_i - 1]
  end

  # We are checking if the value of each element in the index column has the same value as player.sign
  # If that's true then we return true. Having that player has won the game and executing thus logic
  # If any element of the column is not equal to player.sign then that column is invlaid and we return false
  # before we execute any more of the code.
  #
  # The other functions behave similarly

  def check_column(index, player)
    board.each do |column|
      unless column[index] == player.sign
        return false
      end
    end
    true
  end

  def check_row(index, player)
    # column.each do |element|
    board[index].each do |element|
      unless element == player.sign
        return false
      end
    end
    true
  end

  def check_cross(index, player)
    if index == 0
      i = 0
      board.each do |row|
        unless row[i] == player.sign
          return false
        end
        i += 1
      end
    else
      i = 2
      board.each do |row|
        unless row[i] == player.sign
          return false
        end
        i -= 1
      end
    end
  end

  def check_for_win(player)
    if (check_column(0, player) or check_column(1, player) or check_column(2, player)) \
      or (check_row(0, player) or check_row(1, player) or check_row(2, player)) \
      or (check_cross(0, player) or check_cross(1, player))
      return true
    else
      return false
    end
  end

  def win_event(player)
    self.playing = false
    puts ""
    puts "#{player.name} has won!"
    player.points += 1
    puts "Do you want to play again?"
    puts "To play again type 'y' and press enter."
    puts "Otherwise press enter and you'll return to main menu..."
    if gets.chomp == "y"
      interface_object.init_game
    end
    interface_object.clear_console
  end
end
