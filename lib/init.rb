require 'config'

$:.push RUBYGAME_LIBRARY_PATH
$:.push RUBYGAME_EXTENSIONS_PATH

require 'rubygame'
require 'rubygame/mediabag'
require 'inflector' # "borrowed" from rails

require 'mouse_event_dispatcher'
require 'media'
require 'environment'
require 'draggable'
require 'resizeable'
require 'item'
require 'static_item'

# Requires all of the different game item classes
Dir.glob(File.join(File.dirname(__FILE__), "#{ITEMS_PATH}/*.rb")).each do |item|
  require item
end

# Load all the game item images
Dir.glob("../images/items/*.png").each do |item|
  Media.store("images/items/#{item}.png")
end