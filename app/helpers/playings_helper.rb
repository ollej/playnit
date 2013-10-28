module PlayingsHelper
  def get_positions(playings)
    positions = []
    playings.each do |playing|
      positions << playing.position if playing.has_location
    end
    positions
  end
end
