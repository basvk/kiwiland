RSpec.describe KiwilandTracks do
  before do
    KiwilandTracks.create_route(source: 'A', destination: 'B', distance: 5)
    KiwilandTracks.create_route(source: 'B', destination: 'C', distance: 4)
    KiwilandTracks.create_route(source: 'C', destination: 'D', distance: 8)
    KiwilandTracks.create_route(source: 'D', destination: 'C', distance: 8)
    KiwilandTracks.create_route(source: 'D', destination: 'E', distance: 6)
    KiwilandTracks.create_route(source: 'A', destination: 'D', distance: 5)
    KiwilandTracks.create_route(source: 'C', destination: 'E', distance: 2)
    KiwilandTracks.create_route(source: 'E', destination: 'B', distance: 3)
    KiwilandTracks.create_route(source: 'A', destination: 'E', distance: 7)
  end

  let(:node_list) {KiwilandTracks.node_list}
  let(:node_A)    {node_list['A']}
  let(:node_B)    {node_list['B']}
  let(:node_C)    {node_list['C']}
  let(:node_D)    {node_list['D']}
  let(:node_E)    {node_list['E']}

  describe '.create_route' do
    context 'when a new valid source, destination and distance are given' do

      it 'adds the nodes in the node_list' do
        expect(node_list.keys).to include('A', 'B')
      end
    end
  end

  describe '.list_routes' do
    context 'when one or more routes between source and destination exist' do
      let(:result) {KiwilandTracks.list_routes(source: 'A', destination: 'C', depth: 4)}

      it 'returns an array of routes as strings' do
        expect(result.length).to eq 3
        expect(result).to include 'A-B-C-D-C'
        expect(result).to include 'A-D-C-D-C'
        expect(result).to include 'A-D-E-B-C'
      end
    end

    context 'when no routes between source and destination exist' do
      it 'returns an empty array' do
        expect(KiwilandTracks.list_routes(source: 'A', destination: 'Z', max_depth: 99)).to eq []
      end
    end

    context 'when source or destination were not added' do
      it 'returns an empty array' do
        expect(KiwilandTracks.list_routes(source: 'A', destination: 'Y', depth: 4)).to eq []
        expect(KiwilandTracks.list_routes(source: 'Y', destination: 'A', depth: 4)).to eq []
      end
    end

    context 'when multiple options are given' do
      it 'raises an error' do
        expect{KiwilandTracks.list_routes(source: 'A', destination: 'C', depth: 4, max_depth: 4)}.to raise_error 'Expected exactly one of depth, max_depth or max_distance option'
      end
    end

    context 'when no options are given' do
      it 'raises an error' do
        expect{KiwilandTracks.list_routes(source: 'A', destination: 'C')}.to raise_error 'Expected exactly one of depth, max_depth or max_distance option'
      end
    end
  end

  describe '.shortest_route_length' do
    context 'when a route between source and destination exists' do
      it 'returns the shortest route length' do
        expect(KiwilandTracks.shortest_route_length(source: 'A', destination: 'E')).to eq 7
      end
    end

    context 'when no route between source and destination exists' do
      it 'returns nil' do
        expect(KiwilandTracks.shortest_route_length(source: 'C', destination: 'A')).to be_nil
      end
    end

    context 'when source or destination were not added' do
      it 'returns nil' do
        expect(KiwilandTracks.shortest_route_length(source: 'A', destination: 'Y')).to be_nil
      end
    end
  end

  describe '.distance' do
    context 'when a valid and existing route string is given' do
      it 'returns the route length' do
        expect(KiwilandTracks.distance('A-B-C-E')).to eq 11
      end
    end

    context 'when a valid but non-existent route string is given' do
      it 'returns an error string' do
        expect(KiwilandTracks.distance('C-A')).to eq 'NO SUCH ROUTE'
      end
    end

    context 'when an invalid route string is given' do
      it 'raises an error' do
        expect{KiwilandTracks.distance('A-B-C-Y')}.to raise_error 'Unknown node(s) Y in node_list'
      end
    end
  end
end
