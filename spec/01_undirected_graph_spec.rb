require 'rspec'
require '01_undirected_graph'

describe UndirectedVertex do
  describe '#initialize' do
    subject(:vertex) { UndirectedVertex.new(7) }

    it 'stores a value' do
      expect(vertex.value).to eq(7)
    end

    it 'initially sets in_edges as an empty array' do
      expect(vertex.edges).to be_an_instance_of(Array)
      expect(vertex.edges).to be_empty
    end
  end
end

describe UndirectedEdge do
  let(:vertex1) { UndirectedVertex.new(nil) }
  let(:vertex2) { UndirectedVertex.new(nil) }
  subject(:edge) { UndirectedEdge.new(vertex1, vertex2) }

  describe '#initialize' do
    it 'stores a vertices array' do
      expect(edge.vertices).to match_array([vertex1, vertex2])
    end

    it 'stores a cost which defaults to 1' do
      expect(edge.cost).to eq(1)
    end

    it "adds itself to the to_vertex's edges" do
      expect(vertex1.edges).to include(edge)
    end

    it "adds itself to the from_vertex's edges" do
      expect(vertex2.edges).to include(edge)
    end
  end

  describe '#destroy' do
    before(:each) do
      edge.destroy!
    end

    it "deletes itself from its to_vertex and from_vertex's edges" do
      expect(vertex1.edges).to_not include(edge)
      expect(vertex2.edges).to_not include(edge)
    end

    it "sets its vertices to nil" do
      expect(edge.vertices).to be_nil
    end
  end

  describe '#other_vertex' do
    it "gets other vertex" do
      expect(edge.other_vertex(vertex1)).to eq(vertex2)
    end

    it "gets other vertex again" do
      expect(edge.other_vertex(vertex2)).to eq(vertex1)
    end

    it "complains about wrong vertex" do
      (expect do
        edge.other_vertex(UndirectedVertex.new('bogus vertex'))
      end).to raise_error("vertex is at neither end")
    end
  end
end
