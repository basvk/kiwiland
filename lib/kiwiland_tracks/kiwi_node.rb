# This class represents a town in Kiwiland.
# It stores its neighbouring towns and (one-way) distances to those towns as key-values in the @child_nodes hash (towns as keys, distances as values)
# Instances recursively search their child nodes for routes and route lengths.
# Performance limitations: Ruby VM stack depth limits the amount of possible recursion and the depth of the route graph.
module KiwilandTracks
  class KiwiNode
    attr :name

    def initialize(name)
      @name        = name
      @child_nodes = {}
    end

    def add_node(node, distance)
      @child_nodes[node] = distance
    end

    def routes_with_depth(destination, depth, stops: [], results: [])
      stops << self

      if depth == 0
        results << stops if destination == self && stops.length > 1
      else
        @child_nodes.keys.each do |node|
          node.routes_with_depth(destination, depth - 1, stops: stops.dup, results: results)
        end
      end

      results
    end

    def routes_with_max_depth(destination, max_depth, stops: [], results: [])
      stops << self

      results << stops if max_depth >= 0 && destination == self && stops.length > 1

      if max_depth > 0
        @child_nodes.keys.each do |node|
          node.routes_with_max_depth(destination, max_depth - 1, stops: stops.dup, results: results)
        end
      end

      results
    end

    def routes_with_max_distance(destination, max_distance, stops: [], results: [])
      stops << self

      results << stops if destination == self && stops.length > 1

      @child_nodes.each do |node, dist|
        node.routes_with_max_distance(destination, max_distance - dist, stops: stops.dup, results: results) if max_distance - dist > 0
      end

      results
    end

    def shortest_route_length(destination, cumulative_total: 0, visited_nodes: [])
      return nil if visited_nodes.include?(self) # break circular routes

      visited_nodes << self
      length = @child_nodes[destination]

      if length.nil?
        distances = @child_nodes.map{|node, dist| node.shortest_route_length(destination, cumulative_total: dist, visited_nodes: visited_nodes.dup)}
        length    = distances.compact.min
      end

      return nil if length.nil?

      cumulative_total + length
    end

    def total_distance(node_list, cumulative_total: 0)
      node_list = [node_list] if node_list.is_a?(KiwiNode)

      return cumulative_total if node_list.empty?

      next_node = node_list.shift

      return nil unless @child_nodes.include?(next_node)

      cumulative_total += @child_nodes[next_node]
      next_node.total_distance(node_list, cumulative_total: cumulative_total)
    end
  end
end