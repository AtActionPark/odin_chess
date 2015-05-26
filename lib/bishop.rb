class Bishop < Piece

  def initialize player
    @player = player
    @type = "B"
    @display = type + player.to_s

    @moves = []
    8.times do |i|
      @moves << [i,i]
      @moves << [i,-i]
      @moves << [-i,i]
      @moves << [-i,-i]
    end
  end
end