class Minesweeper
  # def after_initialize(rows, columns, mines)
  #   @rows = rows
  #   @columns = columns
  #   @number_of_mines = mines
  #   @cells_with_mines = []
  #   @flipped_cells = []
  #   @flagged_cells = []
  #   @game_over = false
  # end

  def rows
    return @rows
  end

  def columns
    return @columns
  end

  def number_of_mines
    return @number_of_mines
  end

  def cells_with_mines
    return @cells_with_mines
  end

  def flipped_cells
    return @flipped_cells
  end

  def flagged_cells
    return @flagged_cells
  end

  def game_over?
    return @game_over
  end

  def end_game
    @game_over = true
  end

  def set_mines
    while self.cells_with_mines.length < self.number_of_mines
      self.cells_with_mines << [rand(self.rows),rand(self.columns)]
      self.cells_with_mines.uniq!
    end
  end

  def is_mine?(row, column)
    self.cells_with_mines.include?([row, column])
  end

  def number_of_neighbor_mines(row, column)
    mine_count = 0
    (row - 1..row + 1).each do |neighbor_row|
      (column - 1..column + 1).each do |neighbor_col|
        if cell_on_board?(neighbor_row, neighbor_col, row, column) && 
          self.is_mine?(neighbor_row, neighbor_col)
          mine_count += 1
        end
      end
    end
    return mine_count
  end

  def flag(row, column)
    self.flagged_cells << [row, column]
  end

  def flagged?(row, column)
    self.flagged_cells.include? [row, column]
  end

  def flipped?(row, column)
    self.flipped_cells.include? [row, column]
  end

  def flip(row, column)
    self.flipped_cells << [row, column]
    if self.cells_with_mines.include? [row, column]
      self.end_game
    else
      self.flip_neighbors(row, column)
    end
  end

  def flip_neighbors(row, column)
    (row - 1..row + 1).each do |neighbor_row|
      (column - 1..column + 1).each do |neighbor_col|
        if ok_to_flip_neighbor?(neighbor_row, neighbor_col, row, column) && 
          self.number_of_neighbor_mines(neighbor_row, neighbor_col) == 0
          self.flip(neighbor_row, neighbor_col)
        elsif ok_to_flip_neighbor?(neighbor_row, neighbor_col, row, column)
          self.flipped_cells << [neighbor_row, neighbor_col]
        end
      end
    end
  end

  def ok_to_flip_neighbor?(test_row, test_column, row, column)
    cell_on_board?(test_row, test_column, row, column) && 
    !self.is_mine?(test_row, test_column) &&
    !self.flipped?(test_row, test_column)
  end

  def cell_on_board?(test_row, test_column, row, column)
    test_row >= 0 && test_column >= 0 && test_row < self.rows && test_column < self.columns && 
    !(test_row == row && test_column == column)
  end

  def display(row, column)
    if !self.flipped?(row, column) && !self.flagged?(row, column)
      "Blank"
    elsif !self.flipped?(row, column) && self.flagged?(row, column)
      "Flag"
    elsif self.flipped?(row, column) && !self.is_mine?(row, column)
      "Number"
    else
      "Mine"
    end
  end


end
