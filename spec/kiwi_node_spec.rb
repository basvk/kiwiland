RSpec.describe KiwilandTracks::KiwiNode do
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
  let(:node_Z)    {KiwilandTracks::KiwiNode.new('Z')}

  describe '#add_node' do
    context 'when the given node is not a child node (yet)' do
      it 'adds the node and distance to the child nodes list' do
        node_Z.add_node(node_A, 10)
        expect(node_Z.total_distance(node_A)).to eq 10
      end
    end

    context 'when the given node is already a child node' do
      it 'updates the distance for the given node' do
        node_Z.add_node(node_A, 10)
        node_Z.add_node(node_A, 6)
        expect(node_Z.total_distance(node_A)).to eq 6
      end
    end
  end

  describe '#routes_with_depth' do
    context 'when the destination is a (nested) child node' do
      let(:result) {node_A.routes_with_depth(node_C, 4)}

      it 'only returns routes with the given depth' do
        expect(result.length).to eq 3
        expect(result).to include [node_A, node_B, node_C, node_D, node_C]
        expect(result).to include [node_A, node_D, node_C, node_D, node_C]
        expect(result).to include [node_A, node_D, node_E, node_B, node_C]
      end
    end

    context 'when the destination is not a (grand) child' do
      it 'returns the previously found results array' do
        expect(node_A.routes_with_depth(node_Z, 4)).to eq []
      end
    end
  end

  describe '#routes_with_max_depth' do
    context 'when the destination is a (nested) child node' do
      let(:result) {node_A.routes_with_max_depth(node_E, 2)}

      it 'returns an array of routes with a depth lower or same as max_depth' do
        expect(result.length).to eq 2
        expect(result).to include [node_A, node_E]
        expect(result).to include [node_A, node_D, node_E]
      end
    end

    context 'when the destination is not a (grand) child' do
      it 'returns the previously found results array' do
        expect(node_A.routes_with_max_depth(node_Z, 2)).to eq []
      end
    end
  end

  describe '#routes_with_max_distance' do
    context 'when the destination is a (nested) child node' do
      let(:result) {node_A.routes_with_max_distance(node_E, 12)}

      it 'returns an array of routes with a distance shorter than max_distance' do
        expect(result.length).to eq 3
        expect(result).to include [node_A, node_E]
        expect(result).to include [node_A, node_B, node_C, node_E]
        expect(result).to include [node_A, node_D, node_E]
      end
    end

    context 'when the destination is not a (grand) child' do
      it 'returns the previously found results array' do
        expect(node_A.routes_with_max_distance(node_Z, 12)).to eq []
      end
    end
  end

  describe '#shortest_route_length' do
    context 'when the current node has child nodes' do
      context 'when the destination is a direct child node' do
        it 'returns the distance to this child node' do
          expect(node_A.shortest_route_length(node_B)).to eq 5
        end
      end

      context 'when the destination is a nested child node' do
        it 'returns the shortest distance to the destination' do
          expect(node_A.shortest_route_length(node_C)).to eq 9
        end
      end

      context 'when the destination is not a (grand)child' do
        it 'returns nil' do
          expect(node_D.shortest_route_length(node_A)).to be_nil
        end
      end
    end

    context 'when the current node has no child nodes' do
      it 'returns nil' do
        expect(node_Z.shortest_route_length(node_A)).to be_nil
      end
    end
  end

  describe '#distance' do
    context 'when the first stop in the given route is a direct child node' do
      it 'returns the cumulative_distance to the child node' do
        expect(node_A.total_distance(node_B)).to eq 5
      end
    end

    context 'when the first stop in the given route is not a direct child node' do
      it 'returns nil' do
        expect(node_A.total_distance(node_C)).to be_nil
      end
    end
  end
end
