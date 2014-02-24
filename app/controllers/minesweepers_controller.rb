class MinesweepersController < ApplicationController
  include Minesweeper

  def index
    @game = Minesweeper.initialize(8,8,10)
    render :new
  end

end
