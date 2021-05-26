# KiwilandTracks

  $ git clone kiwiland_tracks
  $ cd kiwiland_tracks
  $ bundle
  $ rake

Resulting output:

```
KiwilandTracks::KiwiNode
  #add_node
    when the given node is not a child node (yet)
      adds the node and distance to the child nodes list
    when the given node is already a child node
      updates the distance for the given node
  #routes_with_depth
    when the destination is a (nested) child node
      only returns routes with the given depth
    when the destination is not a (grand) child
      returns the previously found results array
  #routes_with_max_depth
    when the destination is a (nested) child node
      returns an array of routes with a depth lower or same as max_depth
    when the destination is not a (grand) child
      returns the previously found results array
  #routes_with_max_distance
    when the destination is a (nested) child node
      returns an array of routes with a distance shorter than max_distance
    when the destination is not a (grand) child
      returns the previously found results array
  #shortest_route_length
    when the current node has child nodes
      when the destination is a direct child node
        returns the distance to this child node
      when the destination is a nested child node
        returns the shortest distance to the destination
      when the destination is not a (grand)child
        returns nil
    when the current node has no child nodes
      returns nil
  #distance
    when the first stop in the given route is a direct child node
      returns the cumulative_distance to the child node
    when the first stop in the given route is not a direct child node
      returns nil

Kiwiland overall assignment test
 1. The distance of the route A-B-C is 9
 2. The distance of the route A-D is 5
 3. The distance of the route A-D-C is 13
 4. The distance of the route A-E-B-C-D is 22
 5. The distance of the route A-E-D is NO SUCH ROUTE
 6. The number of trips starting at C and ending at C with a maximum of 3 stops is 2 (C-D-C, C-E-B-C)
 7. The number of trips starting at A and ending at C with exactly 4 stops is 3 (A-B-C-D-C, A-D-C-D-C, A-D-E-B-C)
 8. The length of the shortest route (in terms of distance to travel) from A to C is 9
 9. The length of the shortest route (in terms of distance to travel) from B to B is 9
10. The number of different routes from C to C with a distance of less than 30 is 7 (C-D-C, C-D-C-E-B-C, C-D-E-B-C, C-E-B-C, C-E-B-C-D-C, C-E-B-C-E-B-C, C-E-B-C-E-B-C-E-B-C)
  passes the tests

KiwilandTracks
  .create_route
    when a new valid source, destination and distance are given
      adds the nodes in the node_list
  .list_routes
    when one or more routes between source and destination exist
      returns an array of routes as strings
    when no routes between source and destination exist
      returns an empty array
    when source or destination were not added
      returns an empty array
    when multiple options are given
      raises an error
    when no options are given
      raises an error
  .shortest_route_length
    when a route between source and destination exists
      returns the shortest route length
    when no route between source and destination exists
      returns nil
    when source or destination were not added
      returns nil
  .distance
    when a valid and existing route string is given
      returns the route length
    when a valid but non-existent route string is given
      returns an error string
    when an invalid route string is given
      raises an error

Finished in 0.00797 seconds (files took 0.16897 seconds to load)
27 examples, 0 failures
```