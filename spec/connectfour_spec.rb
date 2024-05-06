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
        example_board.row2 = ['-', '-', 'o', '-']
        example_board.board[0] = example_board.row2
        expect(example_board.complete_row?).to be(false)
      end
    end
    context 'when a row is the same' do
      it 'returns true' do
        example_board.row1 = %w[o o o o]
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
        row = ['o', '-', '-', '-']
        example_board.board[0] = row
        example_board.board[1] = row
        example_board.board[2] = row
        example_board.board[3] = row
        expect(example_board.complete_column?).to be(true)
      end
    end
  end
end
