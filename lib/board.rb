class Board
  attr_reader :width, :height
  attr_reader :grid

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
    @play = true
    @win = false
  end

  def create_board
    @grid = Array.new(@width){Array.new(@height,nil)}
  end

  def get_cell i,j
    if i.between?(0,@width-1) && j.between?(0,@height-1)
      @grid[j][i]
    else
      return false
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

  def get_notation_from_coord coord
    return false if coord.length !=2
    letter = @notation.key(coord[0])
    number = 8-coord[1]
    result = letter.to_s+number.to_s
    return result.to_s
  end

  def set_cell i,j,value
    if i.between?(0,@width) && j.between?(0,@height)
      @grid[j][i] = value

    if value != nil
      @grid[j][i].cell = [i,j] 
    end
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
      if check_mate?(2)
        puts "Check Mate, player 1 wins"
        @win = true
        break
      end
      take_turn(2)
      draw_board
      if check_mate?(1)
        puts "Check Mate, player 2 wins"
        @win = true
        break
      end
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
    if get_cell_by_notation(cell_from) == nil
      puts "Can't move an empty piece" if @play == true
      return false  end
    if get_cell_by_notation(cell_from).player != player
      puts "Can't move other player's pieces" if @play == true
      return false end
    if get_cell_by_notation(cell_to) == false
      puts "Can't move to a cell outside bounds" if @play == true
      return false end
    if get_cell_by_notation(cell_to) != nil && get_cell_by_notation(cell_to).player == player
      puts "Can't move to an cell occupied by an ally" if @play == true
      return false end
      if player == 1
        if get_cell_by_notation(cell_to) == search_king(2)
          puts "Can't directly capture the king" if @play == true
          return false end
      else
        if get_cell_by_notation(cell_to) == search_king(1)
          puts "Can't directly capture the king" if @play == true
          return false end
      end

    piece = get_cell_by_notation(cell_from)

    # Can't move if movement is not valid for the piece
    # Case : pawn
    if piece.type == "p"
      # If pawn capturing
      if(get_cell_by_notation(cell_to) != nil && get_cell_by_notation(cell_to).player != player)
        if !piece.valid_move?(get_difference(cell_from, cell_to), true)
          puts "Unvalid move" if @play == true
          return false end
      # If pawn moving normally
      else
        if !piece.valid_move?(get_difference(cell_from, cell_to), false)
          puts "Unvalid move"  if @play == true
          return false end
      end
      # Special case for pawns : after the first move, need to update @moves (cant move by 2 tiles anymore)
      piece.update
    # Case : not pawn
    else
      if !piece.valid_move?(get_difference(cell_from, cell_to))
        puts "Unvalid move" if @play == true
        return false end
    end

    if path_blocked?(cell_from, cell_to)
      puts "Can't move if path is blocked"  if @play == true
      return false end

    # Try the move. If it results in a check for the player moving, reset the board and returns false
    set_cell_by_notation(cell_from, nil)
    if(check?(player) == true)
      set_cell_by_notation(cell_from, piece)
      puts "Move results in check position" if @play == true
      return false
    end

    # Move the piece (create new one at location and delete old one)
    # Could change structure to only change coordinates instead 
    set_cell_by_notation(cell_to, piece)
    set_cell_by_notation(cell_from, nil)

    true
  end

  def try_move cell_from, cell_to, player
    if get_cell_by_notation(cell_from) == nil
      return false  end
    if cell_to == cell_from
      return false  end

    if get_cell_by_notation(cell_to) == false
      return false end
    if get_cell_by_notation(cell_to) != nil && get_cell_by_notation(cell_to).player == player
      return false end
      

    piece = get_cell_by_notation(cell_from)

    # Can't move if movement is not valid for the piece
    # Case : pawn
    if piece.type == "p"
      # If pawn capturing
      if(get_cell_by_notation(cell_to) != nil && get_cell_by_notation(cell_to).player != player)
        if !piece.valid_move?(get_difference(cell_from, cell_to), true)
          return false end
      # If pawn moving normally
      else
        if !piece.valid_move?(get_difference(cell_from, cell_to), false)
          return false end
      end
      # Special case for pawns : after the first move, need to update @moves (cant move by 2 tiles anymore)
      piece.update
    # Case : not pawn
    else
      if !piece.valid_move?(get_difference(cell_from, cell_to))
        return false end
    end

    if path_blocked?(cell_from, cell_to)
      return false end
    true
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

  def check? player
    # Finds the player's King
    king =  search_king(player)
    if king == 'no king found'
      return false
    end
    # Checks all tiles under possible attack
    attacks = []
    if player == 2
      attacks = check_pieces_possible_attacks(1)
    else
      attacks = check_pieces_possible_attacks(2)
    end

    return true if attacks.include?(king.cell)
    return false
  end

  def search_king player
    (0..7).each do |i|
      (0..7).each do |j|
        return get_cell(i,j) if get_cell(i,j) != nil && get_cell(i,j).type == 'K' && get_cell(i,j).player == player
      end
    end
    return 'no king found'
  end

  def check_pieces_possible_attacks player
    possible_attacks = []
    (0..7).each do |i|
      (0..7).each do |j|
        if get_cell(i,j) != nil  && get_cell(i,j).player == player
          p = get_cell(i,j)
          moves = p.moves
          if p.type == "p"
            moves = p.special_moves
          end
          moves.each do |m|
            x = p.cell[0] + m[0]
            y = p.cell[1] - m[1]
            cell = [x,y]
            if get_cell(x,y) != false && try_move(get_notation_from_coord([i,j]), get_notation_from_coord(cell),player) == true
              possible_attacks << cell
            end
          end 
        end
      end
    end
    possible_attacks = possible_attacks.uniq
  end

  def check_pieces_possible_moves player
    (0..7).each do |i|
      (0..7).each do |j|
        if get_cell(i,j) != nil  && get_cell(i,j).player == player
          p = get_cell(i,j)
          #puts "checking #{p}, at position #{p.cell}"
          moves = p.moves
          if p.type == "p"
            p.special_moves.each do |m|
              moves << m
            end
            
          end
          moves.each do |m|
            x = p.cell[0].to_i + m[0].to_i
            y = p.cell[1] - m[1]
            cell = [x,y]
            if get_cell(x,y) != false and get_cell(x,y) == nil
              # Try the move, keep values of initial state
              temp_cell_to = get_cell(x,y)
              temp_cell_from = p

              set_cell(x,y,p)
              if check?(player) == false 
                #puts "no more check if moving #{p} to #{cell} "
                set_cell(x,y,temp_cell_to)
                set_cell(i,j,temp_cell_from)
                return false
              else
                set_cell(x,y,temp_cell_to)
                set_cell(i,j,temp_cell_from)
              end
            end
          end 
        end
      end
    end
    return true
  end

  def check_mate? player
    # Is the player check?
    if check?(player) == false
      return false
    end
    # For all the player pieces, try to move them, if the situation resolves, there is no check_mate
    return check_pieces_possible_moves(player)
  end

end