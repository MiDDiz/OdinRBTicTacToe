class Player
  attr_accessor :points
  attr_reader :sign, :name, :game_handler

  @@player_count = 0
  def initialize(name, sign, game_handler)
    raise "More than two instances of a player are not allowed." if @@player_count >= 2

    @name = name
    @game_handler = game_handler
    @points = 0

    @sign = set_sign(sign)
    @@player_count += 1
  end

  private

  def set_sign(sign)
    if @@player_count.zero? # First player
      if sign.chars.length == 1
        return sign
      else
        return "x"
      end
    else # Second player
      if sign.chars.length == 1 and sign != game_handler.players[0].sign
        return sign
      else
        if game_handler.players[0].sign == "x"
          return "y"
        else
          return "x"
        end
      end
    end
  end
end

class GameBoard
  attr_accessor :board, :playing
  attr_reader :game_object

  def initialize(game_object)
    @board = [%w[- - -], %w[- - -], %w[- - -]]
    @game_object = game_object
  end



  public


  def play(player)
    good_input = false
    until good_input
      spot = get_spot
      if board[spot[0]][spot[1]] == "-"
        good_input = true
        board[spot[0]][spot[1]] = player.sign
        game_object.change_current_player
        if check_for_win(player)
          self.win_event(player)
        end
      else
        puts "That tile is already occupied!"
      end
    end
  end

  def display(player1, player2)
    game_object.clear_console
    turn_mark = ""
    puts "#{player1.name}: #{player1.sign} #{  turn_mark if game_object.current_player == player1 } \t\tPoints: #{player1.points}"
    puts "#{player2.name}: #{player2.sign} #{  turn_mark if game_object.current_player == player2 } \t\tPoints: #{player2.points}"
    puts "\n"
    puts "\t #{board[0][0]} | #{board[0][1]} | #{board[0][2]}"
    puts "\t---|---|---"
    puts "\t #{board[1][0]} | #{board[1][1]} | #{board[1][2]}"
    puts "\t---|---|---"
    puts "\t #{board[2][0]} | #{board[2][1]} | #{board[2][2]}"
    puts "\n"
    puts "#{game_object.current_player.name}'s turn!"
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
      game_object.init_game
    end
    game_object.clear_console
  end
end

class GameHandler
  attr_accessor :players, :current_player


  def initialize
    @players = []
    @game_board = GameBoard.new(self)
    greetings
  end

  public

  def change_current_player
    if self.current_player == players[0]
      self.current_player = players[1]
    else
      self.current_player = players[0]
    end
  end

  def clear_console
    system("clear") || system("cls")
  end

  def init_game
    clear_console
    if players.length == 0
      players << set_player(1)
      players << set_player(2)
      self.current_player = players[0]
    else
      @game_board =GameBoard.new(self)
    end
    @game_board.playing = true
    game_loop
  end

  private

  def greetings
    # Loop until the user picks a valid option.
    loop do
      puts "Hello, and welcome to MiDDiz's Tic Tac Toe!"
      puts "Made entirely on ruby, as a CLI application."
      puts "Please, for start the game enter 's'"
      puts "If you want to exit the aplication enter 'q'"
      puts "Are you interested in the creator? Return 'c'"

      begin
        user_input = gets.chomp.downcase
      rescue StandardError => e
        puts "Erroneous input! #{e}"
        retry
      end

      unless menu_handler(user_input)
        clear_console
        puts "Sorry, \"#{user_input}\" isn't a valid input."
        puts "Please enter a valid input..."
        sleep(2)
        clear_console
      end
    end
  end

  def menu_handler(option)
    case option
    when 's'
      init_game
    when 'q'
      exit(0)
    when 'c'
      credits
    else
      return false
    end
    true
  end





  def game_loop

    while @game_board.playing
      @game_board.display(players[0], players[1])
      @game_board.play(current_player)
    end
  end

  def credits
    clear_console
    puts "______________________________________________"
    puts "|Copyright MiDDiz - 2020 All Rights Reserved.|"
    puts "----------------------------------------------"
    sleep 1
    puts ""
    puts "Part of The Odin Project's curriculum. At the Ruby on Rails track!"
    puts "If you want to see more of my work check me out on my socials: "
    puts "\tGithub: MiDDiz | Twitter: @_MiDDiz"
    sleep 1
    puts ""
    puts "Press return to go to main menu..."
    gets.chomp
    clear_console
  end

  def set_player(index)
    puts "Set the name of your player ##{index}"
    name = gets.chomp
    puts "If you want to use a personalized character in the game type it. Else just return blank (max one char)"
    sign = gets.chomp
    sleep(1)
    clear_console
    Player.new(name, sign, self)
  end
end

game_object = GameHandler.new