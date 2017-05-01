require 'rails_helper'

RSpec.describe AiController, type: :controller do
  let(:active_player) { 1 }

  describe '#random' do

    subject { response.body }

    it 'should return a random number representing one of the columns' do
      game_state = [
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0]
      ].to_json

      put :random, params: { game_state: game_state, active_player: active_player }

      expect(0..6).to include(subject.to_i);
    end

    it 'should not return an invalid column' do
      game_state = [
        [1, 1, 1, 1, 1, 0],
        [1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1]
      ].to_json

      put :random, params: { game_state: game_state, active_player: active_player  }

      expect(subject).to eq '0'
    end
  end

  describe '#easy' do
    subject { response.body }

    it 'should play randomly if there is no win or block condition' do
      game_state = [
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0]
      ].to_json

      put :easy, params: { game_state: game_state, active_player: active_player }

      expect(0..6).to include subject.to_i
    end

    describe 'I WIN plays' do
      it 'should play a column if it will result in a win for verticals' do
        game_state = [
          [0, 0, 0, 0, 0, 0],
          [1, 1, 1, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0]
        ].to_json

        put :easy, params: { game_state: game_state, active_player: active_player }

        expect(subject).to eq '1'
      end

      it 'should play a column if it will result in a win for horizontals' do
        game_state = [
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [1, 0, 0, 0, 0, 0],
          [1, 0, 0, 0, 0, 0],
          [1, 0, 0, 0, 0, 0]
        ].to_json

        put :easy, params: { game_state: game_state, active_player: active_player }

        expect(subject).to eq '3'
      end

      it 'should play a column if it will result in a win for left to right diagonal' do
        game_state = [
          [2, 2, 2, 1, 0, 0],
          [2, 2, 1, 0, 0, 0],
          [2, 1, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0]
        ].to_json

        put :easy, params: { game_state: game_state, active_player: active_player }

        expect(subject).to eq '3'
      end

      it 'should play a column if it will result in a win for right to left diagonal' do
        game_state = [
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [2, 1, 0, 0, 0, 0],
          [2, 2, 1, 0, 0, 0],
          [2, 2, 2, 1, 0, 0]
        ].to_json

        put :easy, params: { game_state: game_state, active_player: active_player }

        expect(subject).to eq '3'
      end
    end

    describe 'I BLOCK plays' do
      let(:active_player) { 2 }

      it 'should play a column if it will block a vertical win' do
        game_state = [
          [0, 0, 0, 0, 0, 0],
          [1, 1, 1, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0]
        ].to_json

        put :easy, params: { game_state: game_state, active_player: active_player }

        expect(subject).to eq '1'
      end

      it 'should play a column if it will block a horizontal win' do
        game_state = [
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [1, 0, 0, 0, 0, 0],
          [1, 0, 0, 0, 0, 0],
          [1, 0, 0, 0, 0, 0]
        ].to_json

        put :easy, params: { game_state: game_state, active_player: active_player }

        expect(subject).to eq '3'
      end

      it 'should play a column if it will block a win for left to right diagonal' do
        game_state = [
          [2, 2, 2, 1, 0, 0],
          [2, 2, 1, 0, 0, 0],
          [1, 1, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0]
        ].to_json

        put :easy, params: { game_state: game_state, active_player: active_player }

        expect(subject).to eq '3'
      end

      it 'should play a column if it will block a win for right to left diagonal' do
        game_state = [
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0],
          [1, 1, 0, 0, 0, 0],
          [2, 2, 1, 0, 0, 0],
          [2, 2, 2, 1, 0, 0]
        ].to_json

        put :easy, params: { game_state: game_state, active_player: active_player }

        expect(subject).to eq '3'
      end
    end
  end
end
