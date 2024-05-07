# frozen_string_literal: true

class Game
  def initialize(game_board = Game_Board.new())
    @game_board = game_board
    @player_one = Player.new('x')
    @player_two = Player.new('o')
  end

  def win_game?
    if @game_board.complete_row? || @game_board.complete_column? || @game_board.complete_diagonal?
      true
    else
      false
    end
  end

  def player_input
    p 'Pick a column from 1 to 7 to play'
    input = gets.chomp
    while Array(1..7).none? { |number| number.to_s == input }
      puts 'Input error! Please enter a number between 1 to 7.'
      input = gets.chomp
    end
    input
  end

  def make_move(player)
    choice = player_input
    @game_board.update_board(choice.to_i, player.token)
    @game_board.board_state
  end

  def play_game
    @game_board.board_state
    until win_game? == true
      make_move(@player_one)
      return p 'Congrats player one!' if win_game? == true

      make_move(@player_two)
      return p 'Congrats player two!' if win_game? == true
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

  def board_state
    board_string = ''
    board.each do |row|
      row_string = '|'
      row.each do |char|
        row_string += char + '|'
      end
      board_string += row_string + "\n"
    end
    puts board_string
  end

  def update_board(column, piece)
    loc = -1
    board.each do |row|
      loc += 1 if row[column - 1] == '-'
    end
    board[loc][column - 1] = piece
  end

  def column_full?(column)
    return true if board[0][column - 1] != '-'

    false
  end
end

class Player
  attr_reader :token

  def initialize(token)
    @token = token
  end
end

# game = Game.new
# game.play_game
