require "kiwiland_tracks/version"
require 'kiwiland_tracks/kiwi_node'

module KiwilandTracks

  @@node_list = {}

  def self.create_route(source:, destination:, distance:)
    raise "Expected source to be a string, got: #{source.inspect}"           unless source.is_a?(String)
    raise "Expected destination to be a string, got: #{destination.inspect}" unless destination.is_a?(String)
    raise "Expected distance to be a number, got: #{destination.inspect}"    unless distance.is_a?(Numeric)

    @@node_list[source]      ||= KiwiNode.new(source)
    @@node_list[destination] ||= KiwiNode.new(destination)

    @@node_list[source].add_node(@@node_list[destination], distance)
  end

  def self.list_routes(source:, destination:, depth: nil, max_depth: nil, max_distance: nil)
    raise "Expected source to be a string, got: #{source.inspect}"             unless source.is_a?(String)
    raise "Expected destination to be a string, got: #{destination.inspect}"   unless destination.is_a?(String)
    raise "Expected exactly one of depth, max_depth or max_distance option"    unless [depth, max_depth, max_distance].compact.length == 1
    raise "Expected depth to be a number, got: #{depth.inspect}"               unless depth.is_a?(Numeric) || depth.nil?
    raise "Expected max_depth to be a number, got: #{max_depth.inspect}"       unless max_depth.is_a?(Numeric) || max_depth.nil?
    raise "Expected max_distance to be a number, got: #{max_distance.inspect}" unless max_distance.is_a?(Numeric) || max_distance.nil?

    return [] unless @@node_list.keys.include?(source) && @@node_list.keys.include?(destination)

    result = @@node_list[source].routes_with_depth(@@node_list[destination], depth)               if depth
    result = @@node_list[source].routes_with_max_depth(@@node_list[destination], max_depth)       if max_depth
    result = @@node_list[source].routes_with_max_distance(@@node_list[destination], max_distance) if max_distance

    # Describe the resulting node lists by their names separated by dashes, e.g. A-B-C
    result.map {|route| route.map(&:name).join('-')}
  end

  def self.shortest_route_length(source:, destination:)
    raise "Expected source to be a string, got: #{source.inspect}"           unless source.is_a?(String)
    raise "Expected destination to be a string, got: #{destination.inspect}" unless destination.is_a?(String)

    return nil unless @@node_list.keys.include?(source) && @@node_list.keys.include?(destination)

    @@node_list[source].shortest_route_length(@@node_list[destination])
  end

 def self.distance(node_list)
    raise "Expected node_list to be a string, got: #{source.inspect}" unless node_list.is_a?(String)
    raise "node_list is empty" if node_list == ''

    node_names    = node_list.split('-').map(&:strip)
    unknown_nodes = node_names - @@node_list.keys

    raise "Unknown node(s) #{unknown_nodes.join(', ')} in node_list" unless unknown_nodes.empty?

    nodes      = @@node_list.values_at(*node_names)
    first_node = nodes.shift
    first_node.total_distance(nodes) || 'NO SUCH ROUTE'
  end

  def self.node_list
    @@node_list
  end
end
