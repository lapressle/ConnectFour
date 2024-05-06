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
end
