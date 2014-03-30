class MinesweepersController < ApplicationController
  # include MinesweeperHelper

  def index
    @game = Minesweeper.new
    @game.after_initialize
    render :new
  end

end
