require 'rails_helper'

RSpec.describe AiController, type: :controller do
  describe '#random' do
    let(:active_player) { 1 }

    subject { response.body.to_i }

    it 'should return a random number representing one of the columns' do
      game_state = [
        [0, 0, 0 , 0, 0, 0],
        [0, 0, 0 , 0, 0, 0],
        [0, 0, 0 , 0, 0, 0],
        [0, 0, 0 , 0, 0, 0],
        [0, 0, 0 , 0, 0, 0],
        [0, 0, 0 , 0, 0, 0],
        [0, 0, 0 , 0, 0, 0]
      ]
      put :random, params: { game_state: game_state, active_player: active_player }

      expect(0..6).to include(subject);
    end

    it 'should not return an invalid column' do
      game_state = [
        [1, 1, 1 , 1, 1, 0],
        [1, 1, 1 , 1, 1, 1],
        [1, 1, 1 , 1, 1, 1],
        [1, 1, 1 , 1, 1, 1],
        [1, 1, 1 , 1, 1, 1],
        [1, 1, 1 , 1, 1, 1],
        [1, 1, 1 , 1, 1, 1]
      ]
      put :random, params: { game_state: game_state, active_player: active_player  }

      expect(subject).to eq 0
    end
  end
end
