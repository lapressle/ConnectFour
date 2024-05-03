# frozen_string_literal: true

class Game
  def initialize(game_board = Game_Board.new())
    @game_board = game_board
  end

  def win_game?
    if @game_board.complete_row? || @game_board.complete_column? || @game_board.complete_diagonal?
      true
    else
      false
    end
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