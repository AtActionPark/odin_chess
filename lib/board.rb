class Board
  attr_reader :width, :height
  attr_reader :grid
  @play = false
  @win = false
  @notation = Hash.new

  def initialize
    @width = 8
    @height = 8
    @notation = {'a' => 0,
                 'b' => 1,
                 'c' => 2,
                 'd' => 3,
                 'e' => 4,
                 'f' => 5,
                 'g' => 6,
                 'h' => 7}
    create_board  
  end

  def create_board
    @grid = Array.new(@width){Array.new(@height,nil)}
  end

  def get_cell i,j
    if i.between?(0,@width) && j.between?(0,@height)
      @grid[j][i]
    else
      "cell (#{i},#{j}) is out of bounds"
    end
  end

  def get_cell_by_notation notation
    return false if get_coord_from_notation(notation) == false
    notation = get_coord_from_notation(notation)
    get_cell(notation[0],notation[1])
  end

  def get_coord_from_notation notation
    return false if notation.length !=2
    notation = notation.split('')
    letter = notation[0].downcase.to_s
    number = notation[1].to_i
    number = 8-number
    return false if !('a'..'h').include?(letter) || !(0..8).include?(number)
    return [@notation[letter], number]
  end

  def set_cell i,j,value
    if i.between?(0,@width) && j.between?(0,@height)
      @grid[j][i] = value
      "cell not empty" if @grid[j][i] != nil
    else
      "out of bounds"
    end
  end

  def set_cell_by_notation notation, value
    return false if get_coord_from_notation(notation) == false
    notation = get_coord_from_notation(notation)
    set_cell(notation[0],notation[1], value)
  end

  def clear_board
     @grid = Array.new(@width){Array.new(@height,nil)}
  end

  def draw_board
    puts ""
    puts " ------------------------"
    i = 8    
    grid.each do |row|
      row.each do |cell|
        if cell != nil
          print "|" + cell.display
        else
          print "|" + "  "
        end
      end
      print "| #{i}"
      puts ""
      puts " -----------------------"
      i-=1
    end
    print "  a  b  c  d  e  f  g  h"
  end

  def play
    populate
    draw_board

    return if !@play
    while !@win 
      take_turn(1)
      draw_board
      take_turn(2)
      draw_board
    end
  end

  def take_turn player
    puts ""
    puts "Player#{player} - input move"
    move = gets.chomp
    move = move.split(' ')
    while do_move(move[0].to_s, move[1].to_s, player) == false do
      puts "Player#{player} - input move"
      move = gets.chomp
      move = move.split(' ')
    end
  end

  def populate
    @width.times do |i|
      set_cell(i,6,Pawn.new(1))
      set_cell(i,1,Pawn.new(2))
    end

    set_cell_by_notation('e1',King.new(1))
    set_cell_by_notation('d1',Queen.new(1))
    set_cell_by_notation('c1',Bishop.new(1))
    set_cell_by_notation('f1',Bishop.new(1))
    set_cell_by_notation('b1',Knight.new(1))
    set_cell_by_notation('g1',Knight.new(1))
    set_cell_by_notation('a1',Tower.new(1))
    set_cell_by_notation('h1',Tower.new(1))

    set_cell_by_notation('e8',King.new(2))
    set_cell_by_notation('d8',Queen.new(2))
    set_cell_by_notation('c8',Bishop.new(2))
    set_cell_by_notation('f8',Bishop.new(2))
    set_cell_by_notation('b8',Knight.new(2))
    set_cell_by_notation('g8',Knight.new(2))
    set_cell_by_notation('a8',Tower.new(2))
    set_cell_by_notation('h8',Tower.new(2))
  end

  def get_difference cell_from, cell_to
    cell_from = get_coord_from_notation(cell_from)
    cell_to = get_coord_from_notation(cell_to)

    result = []
    result << cell_to[0] - cell_from[0]
    result << cell_from[1] - cell_to[1]
  end

  def do_move cell_from, cell_to, player
    # Can't move an empty piece
    return false if get_cell_by_notation(cell_from) == nil
    # Can't move other player's pieces
    return false if get_cell_by_notation(cell_from).player != player
    # Can't move to a cell outside bounds
    return false if get_cell_by_notation(cell_to) == false
    # Can't move to an cell occupied by an ally
    return false if get_cell_by_notation(cell_to) != nil && get_cell_by_notation(cell_to).player == player

    piece = get_cell_by_notation(cell_from)

    # Can't move if movement is not valid for the piece
    return false if !piece.valid_move?(get_difference(cell_from, cell_to))
    # Can't move if path is blocked
    return false if path_blocked?(cell_from, cell_to)

    set_cell_by_notation(cell_to, get_cell_by_notation(cell_from))
    set_cell_by_notation(cell_from, nil)
  end

  def path_blocked? cell_from, cell_to #TO REFACTOR 
    cell_from = get_coord_from_notation(cell_from)
    cell_to = get_coord_from_notation(cell_to)

    #checking vertical movements
    if cell_from[0] == cell_to[0]
      travel = cell_from[1] - cell_to[1]
      if travel >0 #up
        travel -=1
        travel.times.each do |i|
          return true if(get_cell(cell_from[0],cell_from[1]-i-1)) != nil
        end
      else #down
        travel *=-1
        travel -=1
        travel.times.each do |i|
          return true if(get_cell(cell_from[0],cell_from[1]+i+1)) != nil
        end
      end

    #checking horizontal movements
    elsif cell_from[1] == cell_to[1]
      travel = cell_from[0] - cell_to[0]
      if travel >0 #left
        travel -=1
        travel.times.each do |i|
          return true if(get_cell(cell_from[0] -i-1,cell_from[1])) != nil
        end
      else #right
        travel *=-1
        travel -=1
        travel.times.each do |i|
          return true if(get_cell(cell_from[0] +i +1 ,cell_from[1])) != nil
        end
      end

    #checking diagonal movements
    elsif (cell_from[0] - cell_to[0]).abs == (cell_from[1] - cell_to[1]).abs
      ytravel = cell_from[0] - cell_to[0]
      xtravel = cell_from[1] - cell_to[1]
      if xtravel>0 && ytravel <0 #up right
        travel = xtravel-1
        travel.times.each do |i|
          return true if(get_cell(cell_from[0] +i +1,cell_from[1]-i-1)) != nil
        end
      elsif xtravel>0 && ytravel >0 #up left
        travel = xtravel-1
        travel.times.each do |i|
          return true if(get_cell(cell_from[0] -i-1,cell_from[1]-i-1)) != nil
        end
      elsif xtravel<0 && ytravel >0 #down left
        travel = ytravel-1
        travel.times.each do |i|
          return true if(get_cell(cell_from[0] -i -1,cell_from[1]+i+1)) != nil
        end
      elsif xtravel<0 && ytravel <0 #down right
        travel = xtravel.abs-1
        travel.times.each do |i|
          return true if(get_cell(cell_from[0] +i +1,cell_from[1]+i+1)) != nil
        end
      end

      #return true
    end
    return false
        
  end
end