class MinesweepersController < ApplicationController

  def index
    @game = Minesweeper.new(8,8,10)
  end

end