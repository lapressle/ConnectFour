# frozen_string_literal: true

require_relative '../lib/connectfour'

describe Game do
  subject(:example_game) { described_class.new(game_board) }
  let(:game_board) { instance_double(Game_Board) }
  describe '#win_game?' do
    context 'when the board has a complete row' do
      it 'returns true' do
        allow(game_board).to receive(:complete_row?).and_return(true)
        expect(example_game.win_game?).to be(true)
      end
    end

    context 'when the board has a complete column' do
      it 'returns true' do
        allow(game_board).to receive(:complete_row?).and_return(false)
        allow(game_board).to receive(:complete_column?).and_return(true)
        expect(example_game.win_game?).to be(true)
      end
    end

    context 'when the board has a complete diagonal' do
      it 'returns true' do
        allow(game_board).to receive(:complete_row?).and_return(false)
        allow(game_board).to receive(:complete_column?).and_return(false)
        allow(game_board).to receive(:complete_diagonal?).and_return(true)
        expect(example_game.win_game?).to be(true)
      end
    end

    context 'when the board no win conditions are satisfied' do
      it 'returns true' do
        allow(game_board).to receive(:complete_column?).and_return(false)
        allow(game_board).to receive(:complete_diagonal?).and_return(false)
        allow(game_board).to receive(:complete_row?).and_return(false)
        expect(example_game.win_game?).to be(false)
      end
    end
  end

  describe '#player_input' do
    context 'when given the correct input' do
      before do
        io_obj = double
        valid_input = '3'
        allow(example_game).to receive(:gets).and_return(io_obj)
        allow(io_obj).to receive(:chomp).and_return(valid_input)
      end
      it 'stops loop and does not display error message' do
        error_message = 'Input error! Please enter a number between 1 to 7.'
        expect(example_game).not_to receive(:puts).with(error_message)
        example_game.player_input
      end
    end

    context 'when given the incorrect input once then correct input' do
      before do
        io_obj = double
        invalid_input = 'x'
        valid_input = '3'
        allow(example_game).to receive(:gets).and_return(io_obj, io_obj)
        allow(io_obj).to receive(:chomp).and_return(invalid_input, valid_input)
      end
      it 'completes loop and displays error message once' do
        error_message = 'Input error! Please enter a number between 1 to 7.'
        expect(example_game).to receive(:puts).with(error_message).once
        example_game.player_input
      end
    end
  end

  describe '#make_move' do
    let(:player) { double(:player, token: 'x') }
    before do
      allow(example_game).to receive(:player_input).and_return('1')
    end
    it 'call board to update' do
      expect(game_board).to receive(:update_board).once
      expect(game_board).to receive(:board_state).once
      example_game.make_move(player)
    end
  end

  describe '#play_game' do
    let(:player) { double(:player, token: 'x') }
    context 'when win_game? is false once' do
      before do
        allow(game_board).to receive(:board_state)
        allow(example_game).to receive(:win_game?).and_return(false, true)
      end
      it 'runs through make_move once' do
        expect(example_game).to receive(:make_move).once
        example_game.play_game
      end
    end
  end
end

describe Game_Board do
  subject(:example_board) { described_class.new }
  describe '#complete_row?' do
    context 'when no row is the same' do
      it 'returns false' do
        example_board.row2 = ['-', '-', 'o', '-', '-', 'o', '-']
        example_board.board[0] = example_board.row2
        expect(example_board.complete_row?).to be(false)
      end
    end
    context 'when a row is the same' do
      it 'returns true' do
        example_board.row1 = %w[o o o o o o o]
        example_board.board[0] = example_board.row1
        expect(example_board.complete_row?).to be(true)
      end
    end

    context 'when the board is in starting configuration' do
      it 'returns false' do
        expect(example_board.complete_row?).to be(false)
      end
    end
  end

  describe '#complete_column?' do
    context 'when a column is the same' do
      it 'returns true' do
        row = ['o', '-', '-', '-', '-', '-']
        example_board.board.map! { row }
        expect(example_board.complete_column?).to be(true)
      end
    end

    context 'when no column is the same' do
      it 'returns true' do
        row = ['x', '-', '-', '-', 'o', 'x']
        example_board.board[0] = row
        expect(example_board.complete_column?).to be(false)
      end
    end

    context 'when the board is in starting configuration' do
      it 'returns false' do
        expect(example_board.complete_column?).to be(false)
      end
    end
  end

  describe '#complete_diagonal?' do
    context 'when a diagonal is the same' do
      it 'returns true' do
        row1 = ['x', '-', '-', '-', '-', '-', '-']
        row2 = ['-', 'x', '-', '-', '-', '-', '-']
        row3 = ['-', '-', 'x', '-', '-', '-', '-']
        row4 = ['-', '-', '-', 'x', '-', '-', '-']
        row5 = ['-', '-', '-', '-', 'x', '-', '-']
        row6 = ['-', '-', '-', '-', '-', 'x', '-']
        example_board.board[0] = row1
        example_board.board[1] = row2
        example_board.board[2] = row3
        example_board.board[3] = row4
        example_board.board[4] = row5
        example_board.board[5] = row6
        expect(example_board.complete_diagonal?).to be(true)
      end
    end

    context 'when no diagonal is the same' do
      it 'returns true' do
        row1 = ['x', '-', '-', '-', '-', '-', 'x']
        row2 = ['-', 'x', '-', '-', '-', 'o', 'x']
        row3 = ['-', '-', 'o', '-', 'x', '-', 'x']
        row4 = ['-', '-', '-', 'x', '-', '-', '-']
        example_board.board[0] = row1
        example_board.board[1] = row2
        example_board.board[2] = row3
        example_board.board[3] = row4
        expect(example_board.complete_diagonal?).to be(false)
      end
    end

    context 'when the board is in starting configuration' do
      it 'returns false' do
        expect(example_board.complete_diagonal?).to be(false)
      end
    end
  end

  describe '#show_board' do
    it 'returns the current board state' do
      board_state = ''
      6.times do
        board_state += "|-|-|-|-|-|-|-|\n"
      end
      expect(example_board).to receive(:puts).with(board_state)
      example_board.board_state
    end
  end

  describe '#update_board' do
    context 'when a column is given and no previous pieces are in play' do
      it 'replaces filler character with player piece' do
        expect { example_board.update_board(1, 'x') }.to change { example_board.board[-1][0] }.to('x')
      end

      it 'replaces filler character with player piece' do
        expect { example_board.update_board(2, 'o') }.to change { example_board.board[-1][1] }.to('o')
      end
    end

    context 'when a column is given and previous pieces are in play' do
      it 'replaces next filler piece in column with player piece' do
        example_board.board[-1][0] = 'x'
        expect { example_board.update_board(1, 'o') }.to change { example_board.board[-2][0] }.to('o')
      end
    end
  end

  describe '#column_full?' do
    context 'when a column is full of player pieces' do
      it 'returns true' do
        example_board.board.each do |row|
          row[0] = 'x'
        end
        expect(example_board.column_full?(1)).to be(true)
      end
    end

    context 'when a column is not full of player pieces' do
      it 'returns false' do
        expect(example_board.column_full?(1)).to be(false)
      end
    end
  end
end
