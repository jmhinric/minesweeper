describe("Game", function() {
  var game;
  beforeEach(function() {
    game = new Game(8,8,10);
  });

  describe("#setMines", function() {
    it("randomly sets the mines for the game", function() {
      game.setMines();
      expect(game.mineCells.length).toBe(10);
    });
  });
});