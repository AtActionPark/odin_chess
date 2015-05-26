class Queen < Piece

  def initialize player
    @player = player
    @type = "Q"
    @display = type + player.to_s
    @moves = []

    8.times do |i|
      @moves << [i,i]
      @moves << [i,-i]
      @moves << [-i,i]
      @moves << [-i,-i]
      @moves << [i,0]
      @moves << [-i,0]
      @moves << [0,i]
      @moves << [0,-i]
    end
  end
end