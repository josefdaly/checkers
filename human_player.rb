require_relative 'errors'


class HumanPlayer
  attr_reader :color
  attr_writer :board

  def initialize(color)
    @color = color
  end

  def make_move
    sequence = []

    while sequence.uniq.length == sequence.length
      sequence << move_cursor("#{@color}'s turn. \n#{sequence}")
    end

    raise NoPieceSelectedError if @board[sequence.first].nil?
    raise WrongPieceError if @board[sequence.first].color != @color
    raise NoMoveError if sequence.first == sequence.last


    sequence = (sequence.uniq)
    duped_board = @board.deep_dup

    if duped_board[sequence.first].valid_move_sequence?(sequence.drop 1)
      @board[sequence.first].perform_moves!(sequence.drop 1)
    else
      raise BadSequenceError
    end
  end

  def move_cursor(message)
    input = ""
    until input == "\r"
      @board.render(message)
      input = gets.chomp
      @board.cursor[0] += 1 if input == 'k' && @board.cursor[0] + 1 < 8
      @board.cursor[0] -= 1 if input == 'i' && @board.cursor[0] - 1 >= 0
      @board.cursor[1] -= 1 if input == 'j' && @board.cursor[1] - 1 >= 0
      @board.cursor[1] += 1 if input == 'l' && @board.cursor[1] + 1 < 8
    end

    @board.cursor.dup
  end
end
