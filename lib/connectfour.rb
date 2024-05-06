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
  attr_accessor :row1, :row2, :row3, :row4, :board

  def initialize
    @row1 = ['-', '-', '-', '-']
    @row2 = ['-', '-', '-', '-']
    @row3 = ['-', '-', '-', '-']
    @row4 = ['-', '-', '-', '-']
    @board = [@row1, @row2, @row3, @row4]
  end

  def complete_row?
    board.each do |row|
      return true if row.uniq.count <= 1 && row.uniq != ['-']
    end
    false
  end

  def complete_column?
    columns = [[],[],[],[]]
    n = 0
    board.each do |row|
      row.each do |char|
        columns[n].append(char)
        n += 1
      end
      n = 0
    end
    columns.each do |column|
      return true if column.uniq.count <= 1 && column.uniq != ['-']
    end
    false
  end

  def complete_diagonal?; end
end
