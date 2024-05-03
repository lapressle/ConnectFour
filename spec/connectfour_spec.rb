# frozen_string_literal: true

require_relative '../lib/connectfour'

describe Game do
  subject(:example_game) { described_class.new() }
  describe '#win_game?' do
    let(:game_board) { instance_double(Game_Board) }
    context 'when the board has a complete row' do
      it 'returns true' do
        allow(game_board).to receive(:complete_row?).and_return(true)
        expect(example_game.win_game?).to be(true)
      end
    end
  end
end