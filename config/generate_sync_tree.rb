# Since this gem is not included in the Gemfile, just install like this:
#
# $ gem install ruby-graphviz
#
# And then run this script like this:
#
# $ ruby docs/sync_tree_script.rb

require 'graphviz'

class GraphViz
  def add_to(parent, name)
    new = add_nodes(name)
    add_edges(parent, new)
    new
  end
end

class GraphViz::Node
  @@image_count = 0

  def add_node(name)
    root_graph.add_to(self, name)
  end

  def add_image_node
    suffix = ' ' * @@image_count
    image_node = root_graph.add_to(self, "imageNode#{suffix}")
    root_graph.add_to(image_node, "imageThumbnailNode#{suffix}")
    @@image_count += 1
  end
end

graph = GraphViz.new(:G, type: :digraph)

partner_node = graph.add_nodes('partnerNode')
artwork_node = partner_node.add_node('artworkNode')
user_node = partner_node.add_node('userNode')
artwork_node.add_image_node

show_node = partner_node.add_node('showNode')
show_artworks_node = show_node.add_node('showArtworksNode')
show_documents_node = show_node.add_node('showDocumentsNode')
show_installation_shots_node = show_node.add_node('showInstallationShotsNode')
show_installation_shots_node.add_image_node
show_covers_node = show_node.add_node('showCoversNode')
show_covers_node.add_image_node

document_file_node = show_documents_node.add_node('documentFileNode')
document_thumbnail_node = document_file_node.add_node('documentThumbnailNode')

artist_node = partner_node.add_node('artistNode')
artist_documents_node = artist_node.add_node('artistDocumentsNode')
document_file_node = artist_documents_node.add_node('documentFileNode ')

album_node = partner_node.add_node('albumNode')
album_artworks_node = album_node.add_node('albumArtworksNode')

location_node = partner_node.add_node('locationNode')
location_artworks_node = location_node.add_node('locationArtworksNode')

partner_node.add_node('partnerUpdateNode')

graph.output png: 'docs/sync_tree.png'
