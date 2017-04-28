class AiController < ApplicationController
  def random
    binding.pry
    game_state = params[:game_state]
    possible_plays = game_state.map.with_index do |column, index|
      column.any? { |cell| cell == 0 } ? index : nil
    end.compact.flatten

    render json: possible_plays.sample
  end
end
