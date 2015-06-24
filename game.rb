require_relative 'board.rb'
require_relative 'human_player.rb'
require 'sinatra'

class Game
  def initialize(player1 = HumanPlayer.new(:red),
    player2 = HumanPlayer.new(:black))
    @board = Board.new
    @red_player = player1
    @black_player = player2
    @red_player.board = @board
    @black_player.board = @board
    @current_player = @red_player
  end

  def switch_players
    if @current_player == @red_player
      @current_player = @black_player
    else
      @current_player = @red_player
    end
  end

  def play
    until over?
      begin
        @current_player.make_move
        switch_players
      rescue RuntimeError => e
        puts e.message
        puts 'Enter to Continue'
        gets
        retry
      end
    end
    switch_players
    @board.render("")
    puts "#{@current_player.color} wins"
  end

  def over?
    @board.pieces(:red).empty? || @board.pieces(:black).empty?
  end
end

get '/' do
  game = Game.new
  game.play
end
