# frozen_string_literal: true

class Game
  def initialize()
    @game_board = Game_Board.new()
  end

  def win_game?
    true
  end
end

class Game_Board 
  def complete_row?
  end

  def complete_column?
  end

  def complete_diagonal?
  end
end