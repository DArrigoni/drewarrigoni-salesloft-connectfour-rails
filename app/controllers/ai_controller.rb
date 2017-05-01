class AiController < ApplicationController
  MIN_WIN_LENGTH = 4;

  def random
    @game_state = params[:game_state]

    render json: possible_plays.sample
  end

  def easy
    @game_state = params[:game_state]
    @active_player = params[:active_player].to_i

    winning_column = possible_plays.find do |column|
      simulated_game_state = play(@active_player, column)
      result = check_win_for simulated_game_state, @active_player
      result
    end

    play_column = winning_column if winning_column

    unless play_column
      other_player = @active_player == 1 ? 2 : 1

      block_column = possible_plays.find do |column|
        simulated_game_state = play(other_player, column)
        result = check_win_for simulated_game_state, other_player
        result
      end

      play_column = block_column if block_column
    end

    play_column = possible_plays.sample unless play_column

    render json: play_column
  end

  private

  def possible_plays
    @game_state.map.with_index do |column, index|
      column.any? { |cell| cell == 0 } ? index : nil
    end.compact.flatten
  end

  def duplicate_game_state
    Marshal.load(Marshal.dump(@game_state)) #.dup is not enough. Results in pointers to sub arrays
  end

  #Returns a new game state with the play applied
  def play(player, column)
    game_state = duplicate_game_state
    open_index = game_state[column].index(0)
    if open_index
      game_state[column][open_index] = player
      game_state
    else
      nil
    end
  end

  def check_win_for(game_state, active_player)
    player_win_string = active_player.to_s * MIN_WIN_LENGTH #CLEVER: "1111"

    column_strings = generate_column_strings(game_state)
    row_strings = generate_row_strings(game_state)
    ltr_diagonal_strings = generate_ltr_diagonal_strings(game_state)
    rtl_diagonal_strings = generate_ltr_diagonal_strings(game_state.reverse)

    all_strings = column_strings + row_strings + ltr_diagonal_strings + rtl_diagonal_strings

    all_strings.any? { |game_string| game_string.include? player_win_string }
  end

  def generate_column_strings(game_state)
    game_state.map { |column| column.join }
  end

  def generate_row_strings(game_state)
    height = game_state.first.size
    height.times.map do |row|
      game_state.map { |col| col[row] }.join
    end
  end

  def generate_ltr_diagonal_strings(game_state)
    diagonal_string_by_index_sum = Hash.new('')

    game_state.each_with_index do |column, column_index|
      column.each_with_index do |cell_value, row_index|
        index_sum = column_index + row_index

        diagonal_string_by_index_sum[index_sum] += cell_value.to_s
      end
    end

    diagonal_string_by_index_sum.values
  end
end
