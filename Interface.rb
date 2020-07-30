class Interface
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
