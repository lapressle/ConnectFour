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
    @row = ['-', '-', '-', '-', '-', '-', '-']
    @board = [@row, @row, @row, @row, @row, @row]
  end

  def complete_row?
    board.each do |row|
      n = 0
      m = 3
      4.times do
        return true if row[n..m].uniq.count <= 1 && row[n..m].uniq != ['-']

        n += 1
        m += 1
      end
    end
    false
  end

  def make_column
    columns = [[], [], [], [], [], [], []]
    n = 0
    board.each do |row|
      row.each do |char|
        columns[n].append(char)
        n += 1
      end
      n = 0
    end
    columns
  end

  def complete_column?
    columns = make_column
    columns.each do |column|
      n = 0
      m = 3
      3.times do
        return true if column[n..m].uniq.count <= 1 && column[n..m].uniq != ['-']

        n += 1
        m += 1
      end
    end
    false
  end

  def make_diagonal
    diagonal = Array.new(12) { [] }
    n = 0
    m = 6
    4.times do |iter|
      board.each do |row|
        diagonal[0 + iter].append(row[n + iter]) unless row[n + iter].nil?
        diagonal[11 - iter].append(row[m - iter]) unless row[m - iter].nil?
        n += 1
        m -= 1
      end
      n = 0
      m = 6
    end
    board[1..].each do |row|
      diagonal[4].append(row[n])
      diagonal[7].append(row[m])
      n += 1
      m -= 1
    end
    n = 0
    m = 6
    board[2..].each do |row|
      diagonal[5].append(row[n])
      diagonal[6].append(row[m])
      n += 1
      m -= 1
    end
    diagonal
  end

  def complete_diagonal?
    diagonal = make_diagonal
    diagonal.each do |item|
      n = 0
      m = 3
      if item.length == 6
        3.times do
          return true if item[n..m].uniq.count <= 1 && item[n..m].uniq != ['-']

          n += 1
          m += 1
        end
      elsif item.length == 5
        2.times do
          return true if item[n..m].uniq.count <= 1 && item[n..m].uniq != ['-']

          n += 1
          m += 1
        end
      elsif item[n..m].uniq.count <= 1 && item[n..m].uniq != ['-']
        return true
      end
    end
    false
  end
end
