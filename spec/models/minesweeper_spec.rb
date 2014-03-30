require 'pry'
require 'spec_helper'
require_relative '../lib/minesweeper'

describe Minesweeper do
  subject(:game) { Minesweeper.new(8,8,10) }

  describe "::new" do

    describe "#rows" do
      it "has a number of rows" do
        expect(game.rows).to eq 8
      end
    end

    describe "#columns" do
      it "has a number of columns" do
        expect(game.columns).to eq 8
      end
    end

    describe "#number_of_mines" do
      it "returns the initial number of mines on the board" do
        expect(game.number_of_mines).to eq(10)
      end
    end

    describe "#cells_with_mines" do
      it "contains the list of cells that have mines" do
        expect(game.cells_with_mines[0]).to be_nil
      end
    end

    describe "#flipped_cells" do
      it "is a list of cells the user has flipped" do
        expect(game.flipped_cells[0]).to be_nil
      end
    end

    describe "#flagged_cells" do
      it "is a list of cells the user has flagged as mines" do
        expect(game.flagged_cells[0]).to be_nil
      end
    end
  end

  

  describe "#set_mines" do
    before do
      game.set_mines
    end

    it "sets the coordinates of the mines" do
      expect(game.cells_with_mines[0]).to be_a Array
    end

    it "returns unique coordinates for each mine" do
      expect(game.cells_with_mines.uniq.length).to eq 10
    end
  end

  describe "#is_mine?" do
    it "returns whether or not the cell is a mine" do
      game.cells_with_mines << [0,0]
      expect(game.is_mine?(0,0)).to be_true
    end
  end




  describe "#number_of_neighbor_mines" do
    
    context "the tested cell has 8 neighbors and is not a mine" do
      it "returns how many neighbors have mines" do
        game.cells_with_mines << [3,1]
        game.cells_with_mines << [4,2]
        game.cells_with_mines << [4,1]
        expect(game.number_of_neighbor_mines(3,2)).to eq 3
      end
    end

    context "the tested cell has 8 neighbors and is a mine" do
      it "returns how many neighbors have mines" do
        game.cells_with_mines << [3,1]
        game.cells_with_mines << [4,2]
        game.cells_with_mines << [4,1]
        game.cells_with_mines << [3,2]
        expect(game.number_of_neighbor_mines(3,2)).to eq 3
      end
    end

    context "the tested cell is a corner" do
      it "returns how many neighbors have mines" do
        game.cells_with_mines << [1,1]
        game.cells_with_mines << [1,0]
        expect(game.number_of_neighbor_mines(0,0)).to eq 2
      end

      it "returns how many neighbors have mines" do
        game.cells_with_mines << [7,6]
        game.cells_with_mines << [6,7]
        expect(game.number_of_neighbor_mines(7,7)).to eq 2
      end
    end

    context "the tested cell is on an edge" do
      it "returns how many neighbors have mines" do
        game.cells_with_mines << [1,2]
        game.cells_with_mines << [0,2]
        expect(game.number_of_neighbor_mines(0,3)).to eq 2
      end

      it "returns how many neighbors have mines" do
        game.cells_with_mines << [6,2]
        game.cells_with_mines << [7,4]
        expect(game.number_of_neighbor_mines(7,3)).to eq 2
      end

      it "returns how many neighbors have mines" do
        game.cells_with_mines << [3,1]
        game.cells_with_mines << [4,1]
        expect(game.number_of_neighbor_mines(4,0)).to eq 2
      end

      it "returns how many neighbors have mines" do
        game.cells_with_mines << [3,6]
        game.cells_with_mines << [5,7]
        expect(game.number_of_neighbor_mines(4,7)).to eq 2
      end
    end
  end


  describe "#flip" do
    it "changes the cell's flipped state" do
      game.flip(1,3)
      expect(game.flipped?(1,3)).to be_true
    end

    context "the cell has no neighbors with mines" do
      before do
        game.flip(4,4)
      end
      it "flips itself" do
        expect(game.flipped?(4,4)).to be_true
      end
      it "flips its neighbors" do
        expect(game.flipped?(3,3)).to be_true
        expect(game.flipped?(3,4)).to be_true
        expect(game.flipped?(3,5)).to be_true
        expect(game.flipped?(4,3)).to be_true
        expect(game.flipped?(4,5)).to be_true
        expect(game.flipped?(5,3)).to be_true
        expect(game.flipped?(5,4)).to be_true
        expect(game.flipped?(5,5)).to be_true
      end
    end

    context "the cell is not a mine but has a neighbor with a mine" do
      before do
        game.cells_with_mines << [3,4]
        game.cells_with_mines << [3,2]
        game.flip(4,4)
      end

      it "flips itself" do
        expect(game.flipped?(4,4)).to be_true
      end

      it "flips its neighbors that aren't mines" do
        expect(game.flipped?(3,3)).to be_true
        expect(game.flipped?(3,5)).to be_true
        expect(game.flipped?(4,3)).to be_true
        expect(game.flipped?(4,5)).to be_true
        expect(game.flipped?(5,3)).to be_true
        expect(game.flipped?(5,4)).to be_true
        expect(game.flipped?(5,5)).to be_true
      end

      it "doesn't flip neighbors that are mines" do
        expect(game.flipped?(3,4)).to be_false
      end

      it "flips neighbors of neighbors with zero neighbors with mines" do
        expect(game.flipped?(6,2)).to be_true
        expect(game.flipped?(6,3)).to be_true
        expect(game.flipped?(6,4)).to be_true
      end

      it "doesn't flip neighbors of neighbors that have at least one neighbor with a mine" do
        expect(game.flipped?(3,4)).to be_false
      end

      it "doesn't end the game" do
        expect(game.game_over?).to be_false
      end
    end

    context "the flipped cell is a mine" do
      before do
        game.cells_with_mines << [3,4]
        game.flip(3,4)
      end

      it "ends the game" do
        expect(game.game_over?).to be_true
      end
    end

  end
  
  describe "#flipped?" do
    it "initializes as false" do
      expect(game.flipped?(6,3)).to be_false
    end

    it "returns true if the cell has been flipped" do
      game.flip(2,4)
      expect(game.flipped?(2,4)).to be_true
    end
  end



  describe "#flag" do
    it "flags a cell as a mine" do
      game.flag(5,5)
      expect(game.flagged_cells).to include([5,5])
    end
  end

  describe "#flagged?" do
    it "tells whether a cell has been flagged" do
      game.flag(7,7)
      expect(game.flagged?(7,7)).to be_true
    end
  end



  describe "#display" do
    context "the cell is not flipped or flagged" do
      it "displays as blank" do
        expect(game.display(3,3)).to eq("Blank")
      end
    end

    context "the cell is flagged but not flipped" do
      it "displays being flagged" do
        game.flag(3,4)
        expect(game.display(3,4)).to eq("Flag")
      end
    end

    context "the cell is flipped but not a mine" do
      it "displays its number of neighbor mines" do
        game.flip(3,4)
        expect(game.display(3,4)).to eq("Number")
      end
    end

    context "the cell is flipped and a mine" do
      it "displays being a mine" do
        game.flip(3,4)
        game.cells_with_mines << [3,4]
        expect(game.display(3,4)).to eq("Mine")
      end
    end
  end

end

























