require_relative 'piece'
require 'colorize'
require 'io/console'

class Board

  attr_accessor :grid, :cursor


  def initialize(setup = true)
    @cursor = [0,0]
    @grid = Array.new(8) {Array.new(8)}

    populate_board if setup
  end

  def populate_board
    [:red, :black].each do |color|
      @grid.each_with_index do |row,i|
        row.each_with_index do |space,j|
          if color == :red
            if i.between?(0,2) && (i+j).even?
              @grid[i][j] = Piece.new(color, self, [i,j])
            end
          else
            if i.between?(5,7) && (i+j).even?
              @grid[i][j] = Piece.new(color, self, [i,j])
            end
          end
        end
      end
    end
  end

  def pieces(color)
    pieces = []
    @grid.each_with_index do |row, i|
      row.each_with_index do |space, j|
        pieces << self.grid[i][j] if !space.nil? && space.color == color
      end
    end
    pieces
  end

  def render(message)
    system('clear')
    @grid.each_with_index do |row, i|
      @grid[i].each_with_index do |space, j|
        if [i,j] == @cursor
          background = :yellow
        else
          background = :light_blue if (i + j).odd?
          background = :cyan if (i + j).even?
        end
        if space.nil?
          print "  ".colorize(:background => background)
        else
          print "#{@grid[i][j].symbol} ".colorize(:color => space.color, :background => background)
        end
      end
      puts

    end
    puts message
  end

  def deep_dup
    dup_board = Board.new(false)

    [:black, :red].each do |color|
      pieces(color).each do |piece|
        duped_piece = piece.dup
        dup_board[piece.pos] = duped_piece
        duped_piece.board = dup_board
      end
    end

    dup_board
  end

  def [](pos)
    @grid[pos.first][pos.last]
  end

  def []=(pos, piece)
    # debugger if @grid[pos.first].nil?
    @grid[pos.first][pos.last] = piece
  end

  def on_board?(pos)
    return pos.first.between?(0,7) && pos.last.between?(0,7)

  end


  def piece_at(pos)
    self[pos]
  end

  def piece_there?(pos)
    return true unless @grid[pos.first][pos.last].nil?
    false
  end


end
