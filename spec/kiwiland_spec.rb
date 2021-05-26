RSpec.describe 'Kiwiland overall assignment test' do
  it 'passes the tests' do
    KiwilandTracks.create_route(source: 'A', destination: 'B', distance: 5)
    KiwilandTracks.create_route(source: 'B', destination: 'C', distance: 4)
    KiwilandTracks.create_route(source: 'C', destination: 'D', distance: 8)
    KiwilandTracks.create_route(source: 'D', destination: 'C', distance: 8)
    KiwilandTracks.create_route(source: 'D', destination: 'E', distance: 6)
    KiwilandTracks.create_route(source: 'A', destination: 'D', distance: 5)
    KiwilandTracks.create_route(source: 'C', destination: 'E', distance: 2)
    KiwilandTracks.create_route(source: 'E', destination: 'B', distance: 3)
    KiwilandTracks.create_route(source: 'A', destination: 'E', distance: 7)

    result_1 = KiwilandTracks.distance('A-B-C')
    puts " 1. The distance of the route A-B-C is #{result_1}"
    expect(result_1).to eq 9

    result_2 = KiwilandTracks.distance('A-D')
    puts " 2. The distance of the route A-D is #{result_2}"
    expect(result_2).to eq 5

    result_3 = KiwilandTracks.distance('A-D-C')
    puts " 3. The distance of the route A-D-C is #{result_3}"
    expect(result_3).to eq 13

    result_4 = KiwilandTracks.distance('A-E-B-C-D')
    puts " 4. The distance of the route A-E-B-C-D is #{result_4}"
    expect(result_4).to eq 22

    result_5 = KiwilandTracks.distance('A-E-D')
    puts " 5. The distance of the route A-E-D is #{result_5}"
    expect(result_5).to eq 'NO SUCH ROUTE'

    result_6 = KiwilandTracks.list_routes(source: 'C', destination: 'C', max_depth: 3)
    puts " 6. The number of trips starting at C and ending at C with a maximum of 3 stops is #{result_6.length} (#{result_6.join(', ')})"
    expect(result_6.length).to eq 2

    result_7 = KiwilandTracks.list_routes(source: 'A', destination: 'C', depth: 4)
    puts " 7. The number of trips starting at A and ending at C with exactly 4 stops is #{result_7.length} (#{result_7.join(', ')})"
    expect(result_7.length).to eq 3

    result_8 = KiwilandTracks.shortest_route_length(source: 'A', destination: 'C')
    puts " 8. The length of the shortest route (in terms of distance to travel) from A to C is #{result_8}"
    expect(result_8).to eq 9

    result_9 = KiwilandTracks.shortest_route_length(source: 'B', destination: 'B')
    puts " 9. The length of the shortest route (in terms of distance to travel) from B to B is #{result_9}"
    expect(result_9).to eq 9

    result_10 = KiwilandTracks.list_routes(source: 'C', destination: 'C', max_distance: 30)
    puts "10. The number of different routes from C to C with a distance of less than 30 is #{result_10.length} (#{result_10.join(', ')})"
    expect(result_10.length).to eq 7
  end
end
