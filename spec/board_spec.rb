require 'spec_helper'

describe "Board" do
  let(:board) {Board.new}

  before(:each) do
    board.clear_board
  end

  describe "#initialize" do
    it "creates a properly sized empty 2d array" do
      expect(board.grid[0][0]).to eql nil
      expect(board.grid[7][7]).to eql nil
    end
  end

  describe "#get_cell" do
    it "allows to read cell value" do
      expect(board.get_cell(0,0)).to eql nil
    end

    it "returns an error message when accessing out of bounds values" do
      expect(board.get_cell(-1,2)).to eql "cell (-1,2) is out of bounds"
      expect(board.get_cell(2,30)).to eql "cell (2,30) is out of bounds"
    end
  end

  describe "#get_cell_by_notation" do
    it "allows to get a cell by giving the notation instead of the coordinates" do  
      board.set_cell(0,0,1)
      expect(board.get_cell(0,0)).to eql board.get_cell_by_notation('a8')
      board.set_cell(1,1,1)
      expect(board.get_cell(1,1)).to eql board.get_cell_by_notation('b7')
      board.set_cell(3,4,1)
      expect(board.get_cell(3,4)).to eql board.get_cell_by_notation('d4')
      board.set_cell(7,7,1)
      expect(board.get_cell(7,7)).to eql board.get_cell_by_notation('h1')
    end

    it "returns false if incorrect input" do
      expect(board.get_cell_by_notation('i7')).to eql false
      expect(board.get_cell_by_notation('a9')).to eql false
    end
  end

  describe "#set_cell" do
    it "allows to set cell value" do
      board.set_cell(0,0,1)
      expect(board.get_cell(0,0)).to eql 1
    end

    it "returns an error message when accessing out of bounds values" do
      expect(board.set_cell(-1,2, 1)).to eql "out of bounds"
      expect(board.set_cell(2,30, 1)).to eql "out of bounds"
    end

    it "returns an error message when setting a non empty cell" do
      board.set_cell(0,0,1)
      expect(board.set_cell(0,0,2)).to eql "cell not empty"
    end
  end

  describe "#set_cell_by_notation" do
    it "allows to set a cell by giving the notation instead of the coordinates" do
      board.set_cell_by_notation('a8',1)
      expect(board.get_cell_by_notation('a8')).to eql 1
      board.set_cell_by_notation('d5',1)
      expect(board.get_cell_by_notation('d5')).to eql 1
      board.set_cell_by_notation('h1',1)
      expect(board.get_cell_by_notation('h1')).to eql 1
    end

    it "returns false if incorrect input" do
      expect(board.set_cell_by_notation('i7', 1)).to eql false
      expect(board.set_cell_by_notation('a9', 1)).to eql false
    end
  end

  describe "#clear_board" do 
    it "sets all the cells to nil" do
      board.set_cell(0,0,1)
      board.set_cell(1,0,1)
      board.set_cell(2,0,1)
      board.set_cell(3,0,1)

      board.clear_board

      expect(board.get_cell(0,0)).to eql nil
      expect(board.get_cell(1,0)).to eql nil
      expect(board.get_cell(2,0)).to eql nil
      expect(board.get_cell(3,0)).to eql nil
    end
  end

  describe "#get_difference" do
    it "returns the difference between two cells" do
      expect(board.get_difference("a1", "a3")).to eql [0,2]
      expect(board.get_difference("a1", "c4")).to eql [2,3]
      expect(board.get_difference("c4", "a1")).to eql [-2,-3]
    end
  end

  describe "#do_move" do
    it "moves the piece from/to a position" do
      p = Pawn.new(1)
      board.set_cell_by_notation("a2", p)
      board.do_move("a2", "a3", 1)
      expect(board.get_cell_by_notation("a2")).to eql nil
      expect(board.get_cell_by_notation("a3")).to eql p

      board.clear_board
      p = Pawn.new(2)
      board.set_cell_by_notation("a7", p)
      board.do_move("a7", "a6", 2)
      expect(board.get_cell_by_notation("a7")).to eql nil
      expect(board.get_cell_by_notation("a6")).to eql p

      board.clear_board
      p = Knight.new(1)
      board.set_cell_by_notation("b1", p)
      board.do_move("b1", "c3", 1)
      expect(board.get_cell_by_notation("b1")).to eql nil
      expect(board.get_cell_by_notation("c3")).to eql p
     
      board.clear_board
      p = Tower.new(1)
      board.set_cell_by_notation("c1", p)
      board.do_move("c1", "c5", 1)
      expect(board.get_cell_by_notation("c1")).to eql nil
      expect(board.get_cell_by_notation("c5")).to eql p

      board.clear_board
      p = Tower.new(1)
      board.set_cell_by_notation("c5", p)
      board.do_move("c5", "c1", 1)
      expect(board.get_cell_by_notation("c5")).to eql nil
      expect(board.get_cell_by_notation("c1")).to eql p

      board.clear_board
      p = Queen.new(1)
      board.set_cell_by_notation("c1", p)
      board.do_move("c1", "h1", 1)
      expect(board.get_cell_by_notation("c1")).to eql nil
      expect(board.get_cell_by_notation("h1")).to eql p

      board.clear_board
      p = Bishop.new(1)
      board.set_cell_by_notation("b1", p)
      board.do_move("b1", "f5", 1)
      expect(board.get_cell_by_notation("b1")).to eql nil
      expect(board.get_cell_by_notation("f5")).to eql p

      board.clear_board
      p = Bishop.new(1)
      board.set_cell_by_notation("a1", p)
      board.do_move("a1", "h8", 1)
      expect(board.get_cell_by_notation("a1")).to eql nil
      expect(board.get_cell_by_notation("h8")).to eql p
    end

    it "returns false if the type of move is not valid for the piece " do
      p = Pawn.new(1)
      board.set_cell_by_notation("a1", p)
      expect(board.do_move("a1", "c4", 1)).to eql false

      p = Pawn.new(1)
      board.set_cell_by_notation("a8", p)
      expect(board.do_move("a8", "a9", 1)).to eql false

      p = Pawn.new(2)
      board.set_cell_by_notation("a1", p)
      expect(board.do_move("a1", "a-1", 2)).to eql false

      p = Knight.new(1)
      board.set_cell_by_notation("b1", p)
      expect(board.do_move("b1", "c4", 1)).to eql false

      p = Knight.new(1)
      board.set_cell_by_notation("g1", p)
      expect(board.do_move("g1", "g2", 1)).to eql false
    end

    it "returns false if the path is blocked" do
      p1 = Tower.new(1)
      p2 = Tower.new(2)
      board.set_cell_by_notation("a1", p1)
      board.set_cell_by_notation("a4", p2)
      expect(board.do_move("a1", "a8", 1)).to eql false

      board.clear_board
      p1 = Tower.new(1)
      p2 = Tower.new(2)
      board.set_cell_by_notation("a1", p1)
      board.set_cell_by_notation("c1", p2)
      expect(board.do_move("a1", "h1", 1)).to eql false

      board.clear_board
      p1 = Bishop.new(1)
      p2 = Bishop.new(2)
      board.set_cell_by_notation("a1", p1)
      board.set_cell_by_notation("d4", p2)
      expect(board.do_move("a1", "h8", 1)).to eql false

      board.clear_board
      p1 = Bishop.new(1)
      p2 = Bishop.new(2)
      board.set_cell_by_notation("h8", p1)
      board.set_cell_by_notation("d4", p2)
      expect(board.do_move("h8", "a1", 1)).to eql false

      board.clear_board
      p1 = Bishop.new(1)
      p2 = Bishop.new(2)
      board.set_cell_by_notation("a8", p1)
      board.set_cell_by_notation("e4", p2)
      expect(board.do_move("a8", "h1", 1)).to eql false

      board.clear_board
      p1 = Bishop.new(1)
      p2 = Bishop.new(2)
      board.set_cell_by_notation("h1", p1)
      board.set_cell_by_notation("e4", p2)
      expect(board.do_move("h1", "a8", 1)).to eql false
    end

    it "returns false if the destination is an allied piece" do
      board.clear_board
      p1 = Bishop.new(1)
      p2 = Bishop.new(1)
      board.set_cell_by_notation("h1", p1)
      board.set_cell_by_notation("a8", p2)
      expect(board.do_move("h1", "a8", 1)).to eql false

      board.clear_board
      p1 = Knight.new(1)
      p2 = Knight.new(1)
      board.set_cell_by_notation("a1", p1)
      board.set_cell_by_notation("c2", p2)
      expect(board.do_move("a1", "c2", 1)).to eql false
    end

    it "replaces piece already on the cell" do
      p1 = Pawn.new(1)
      p2 = Pawn.new(2)

      board.set_cell_by_notation("a2", p1)
      board.set_cell_by_notation("a3", p2)

      board.do_move("a2", "a3", 1)
      expect(board.get_cell_by_notation("a3")).to eql p1

      N1 = Knight.new(1)
      p2 = Pawn.new(2)

      board.set_cell_by_notation("a1", N1)
      board.set_cell_by_notation("b3", p2)

      board.do_move("a1", "b3", 1)
      expect(board.get_cell_by_notation("b3")).to eql N1

    board.clear_board

      p1 = Tower.new(1)
      p2 = Tower.new(2)

      board.set_cell_by_notation("a1", p1)
      board.set_cell_by_notation("a8", p2)

      board.do_move("a1", "a8", 1)
      expect(board.get_cell_by_notation("a8")).to eql p1
    end
  end

end