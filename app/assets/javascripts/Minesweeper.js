function Game(rows, columns, mines) {
  this.rows = rows;
  this.columns = columns;
  this.numMines = mines;
  this.mineCells = [];

}

Game.prototype.setMines = function(){
  do {
    this.mineCells.push(
      _.sample(_.range(this.rows), 1).toString() +
      _.sample(_.range(this.columns), 1).toString());
    _.uniq(this.mineCells);
  } while (this.mineCells.length < this.numMines);
  
  this.mineCells = _.map(this.mineCells, function(value) {
    return [value[0], value[1]];
  });
};

  