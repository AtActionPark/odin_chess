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

    it "returns false when accessing out of bounds values" do
      expect(board.get_cell(-1,2)).to eql false
      expect(board.get_cell(2,30)).to eql false
    end
  end

  describe "#get_cell_by_notation" do
    it "allows to get a cell by giving the notation instead of the coordinates" do  
      board.set_cell(0,0,Pawn.new(1))
      expect(board.get_cell(0,0)).to eql board.get_cell_by_notation('a8')
      board.set_cell(1,1,Pawn.new(1))
      expect(board.get_cell(1,1)).to eql board.get_cell_by_notation('b7')
      board.set_cell(3,4,Pawn.new(1))
      expect(board.get_cell(3,4)).to eql board.get_cell_by_notation('d4')
      board.set_cell(7,7,Pawn.new(1))
      expect(board.get_cell(7,7)).to eql board.get_cell_by_notation('h1')
    end

    it "returns false if incorrect input" do
      expect(board.get_cell_by_notation('i7')).to eql false
      expect(board.get_cell_by_notation('a9')).to eql false
    end
  end

  describe "#set_cell" do
    it "allows to set cell value" do
      p = Pawn.new(1)
      board.set_cell(0,0,p)
      expect(board.get_cell(0,0).display).to eql p.display
    end

    it "returns an error message when accessing out of bounds values" do
      p = Pawn.new(1)
      expect(board.set_cell(-1,2, p)).to eql "out of bounds"
      expect(board.set_cell(2,30, p)).to eql "out of bounds"
    end

    it "returns an error message when setting a non empty cell" do
      p = Pawn.new(1)
      board.set_cell(0,0,p)
      expect(board.set_cell(0,0,p)).to eql "cell not empty"
    end
  end

  describe "#set_cell_by_notation" do
    it "allows to set a cell by giving the notation instead of the coordinates" do
      p = Pawn.new(1)
      board.set_cell_by_notation('a8',p)
      expect(board.get_cell_by_notation('a8').display).to eql p.display
      board.set_cell_by_notation('d5',p)
      expect(board.get_cell_by_notation('d5').display).to eql p.display
      board.set_cell_by_notation('h1',p)
      expect(board.get_cell_by_notation('h1').display).to eql p.display
    end

    it "returns false if incorrect input" do
      p = Pawn.new(1)
      expect(board.set_cell_by_notation('i7', p)).to eql false
      expect(board.set_cell_by_notation('a9', p)).to eql false
    end
  end

  describe "#clear_board" do 
    it "sets all the cells to nil" do
      p = Pawn.new(1)
      board.set_cell(0,0,p)
      board.set_cell(1,0,p)
      board.set_cell(2,0,p)
      board.set_cell(3,0,p)

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
      board.do_move("a2", "a4", 1)
      expect(board.get_cell_by_notation("a2")).to eql nil
      expect(board.get_cell_by_notation("a4")).to eql p

      board.clear_board
      p = Pawn.new(2)
      board.set_cell_by_notation("a7", p)
      board.do_move("a7", "a5", 2)
      expect(board.get_cell_by_notation("a7")).to eql nil
      expect(board.get_cell_by_notation("a5")).to eql p

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

      N1 = Knight.new(1)
      p2 = Pawn.new(2)

      board.set_cell_by_notation("a1", N1)
      board.set_cell_by_notation("b3", p2)

      board.do_move("a1", "b3", 1)
      expect(board.get_cell_by_notation("b3")).to eql N1
    end

    it "accounts for pawns moving 1 or 2 tiles from initial row"  do
      p = Pawn.new(1)
      board.set_cell_by_notation("a2", p)
      board.do_move("a2", "a4", 1)
      expect(board.get_cell_by_notation("a4")).to eql p
      board.do_move("a4", "a5", 1)
      expect(board.get_cell_by_notation("a5")).to eql p

      p = Pawn.new(1)
      board.set_cell_by_notation("b2", p)
      board.do_move("b2", "b3", 1)
      expect(board.get_cell_by_notation("b3")).to eql p
      board.do_move("b3", "b4", 1)
      expect(board.get_cell_by_notation("b4")).to eql p
    end

    it "accounts for pawns only capturing in diagonal" do 
      p = Pawn.new(1)
      board.set_cell_by_notation("a2", p)
      p = Pawn.new(2)
      board.set_cell_by_notation("a3", p)
      expect(board.do_move("a2", "a3", 1)).to eql false

      board.clear_board
      p = Pawn.new(1)
      board.set_cell_by_notation("a2", p)
      p = Pawn.new(2)
      board.set_cell_by_notation("b3", p)
      expect(board.do_move("a2", "b3", 1)).to eql true
    end

    it "returns false if the move would result in a check" do 
      p = King.new(1)
      board.set_cell_by_notation("a1", p)
      p = Pawn.new(1)
      board.set_cell_by_notation("b2", p)
      p = Bishop.new(2)
      board.set_cell_by_notation("h8", p)
      expect(board.do_move("b2", "b3", 1)).to eql false

      p = King.new(1)
      board.set_cell_by_notation("b1", p)
      p = Bishop.new(2)
      board.set_cell_by_notation("h8", p)
      expect(board.do_move("b1", "a1", 1)).to eql false

    end
  end

  describe "check?" do 
    it "recognizes check scenarios" do 
      p1 = Tower.new(1)
      p2 = King.new(2)
      p3 = King.new(1)
      board.set_cell_by_notation("a1", p1)
      board.set_cell_by_notation("a4", p2)
      board.set_cell_by_notation("g1", p3)
      expect(board.check?(2)).to eql true
      expect(board.check?(1)).to eql false

      board.clear_board
      p1 = Bishop.new(1)
      p2 = King.new(2)
      board.set_cell_by_notation("a1", p1)
      board.set_cell_by_notation("h8", p2)
      expect(board.check?(2)).to eql true

      board.clear_board
      p1 = Knight.new(1)
      p2 = King.new(2)
      board.set_cell_by_notation("d4", p1)
      board.set_cell_by_notation("e2", p2)
      expect(board.check?(2)).to eql true

      board.clear_board
      p1 = Pawn.new(1)
      p2 = King.new(2)
      board.set_cell_by_notation("a1", p1)
      board.set_cell_by_notation("b2", p2)
      expect(board.check?(2)).to eql true

      board.clear_board
      p1 = Pawn.new(2)
      p2 = King.new(1)
      board.set_cell_by_notation("f4", p1)
      board.set_cell_by_notation("e3", p2)
      expect(board.check?(1)).to eql true
    end
  end

end