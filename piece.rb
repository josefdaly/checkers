

class Piece
  attr_reader :color
  attr_accessor :pos, :board

  def initialize(color, board, pos)
    @king = false
    @color = color
    @board = board
    @pos = pos
  end

  def symbol
    if @king == true
      'K'
    else
      '*'
    end
  end

  def move_dirs
    return [[1,1], [1, -1]] unless @king
    return [[1,1], [1, -1], [-1, 1], [-1, -1]]
  end

  def perform_slide(move)
    if possible_moves.include?(move)
      @board[@pos] = nil
      @pos = move
      @board[move] = self
      king_me
      return true
    end
    false
  end

  def king_me
    @king = true if @color == :red && @pos.first == 7
    @king = true if @color == :black && @pos.first == 0
  end

  def other_color
    color == :black ? :red : :black
  end

  def perform_jump(move)
    if possible_jumps.keys.include?(move)
      jumped_pos = possible_jumps[move]
      @board[jumped_pos] = nil
      @board[@pos] = nil
      @board[move] = self
      @pos = move
      king_me
      return true
    end
    false
  end

  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      if self.possible_moves.include?(move_sequence.first)
        perform_slide(move_sequence.shift)
      elsif self.possible_jumps.include?(move_sequence.first)
        perform_jump(move_sequence.first)
      else
        raise BadSequenceError
      end
    else
      until move_sequence.empty?
        if self.possible_jumps.include?(move_sequence.first)
          perform_jump(move_sequence.shift)
        else
          raise BadSequenceError
        end
      end
    end
  end

  def valid_move_sequence?(move_sequence)
    begin
      self.perform_moves!(move_sequence)
    rescue BadSequenceError => e      
      return false
    end
    return true
  end


  def possible_jumps
    (@color == :black) ? (modifier = -1) : (modifier = 1)
    jumps = {}
    move_dirs.each do |move|
      potential_jump = [((move.first * modifier) * 2 + @pos.first) , move.last * 2 + pos.last]
      space_between = [(move.first * modifier) + @pos.first , move.last + pos.last]
        if valid_jump?(space_between, potential_jump)
          jumps[potential_jump] = space_between
        end
    end

    jumps
  end

  def valid_jump?(space_between, landing_space)
    @board.on_board?(landing_space) &&
      !@board[space_between].nil? &&
        @board[space_between].color == other_color &&
          @board[landing_space].nil?

  end

  def possible_moves
    (@color == :black) ? (modifier = -1) : (modifier = 1)
    moves = []
    move_dirs.each do |move|
      potential_move = [(move.first * modifier) + @pos.first , move.last + pos.last]
      if @board.on_board?(potential_move) && @board[potential_move].nil?
        moves << potential_move
      end
    end
    moves
  end
end
