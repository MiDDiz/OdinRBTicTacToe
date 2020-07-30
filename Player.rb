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
