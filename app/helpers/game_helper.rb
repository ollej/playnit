module GameHelper
  def get_primary_name(game)
    return if game.nil? or !game.has_key? 'name'
    game['name'].map { |n| n['value'] }
  end
end
