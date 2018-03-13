require 'rspec'
require '02_topological_sort'

describe 'TopologicalSort' do
  let(:v1) { DirectedVertex.new("Wash Markov") }
  let(:v2) { DirectedVertex.new("Feed Markov") }
  let(:v3) { DirectedVertex.new("Dry Markov") }
  let(:v4) { DirectedVertex.new("Brush Markov") }
  let(:v5) { DirectedVertex.new("Cuddle Markov") }
  let(:v6) { DirectedVertex.new("Walk Markov") }
  let(:v7) { DirectedVertex.new("Teach Markov") }
  let(:v8) { DirectedVertex.new("Worship Markov") }

  it "sorts two vertices" do
    vertices = [v1, v2]
    vertices.shuffle!
    solutions = [
      [v1.value, v2.value],
    ]

    DirectedEdge.new(v1, v2)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "sorts three vertices" do
    vertices = [v1, v2, v3]
    vertices.shuffle!
    solutions = [
      [v1.value, v2.value, v3.value],
    ]

    # Linear order
    DirectedEdge.new(v1, v2)
    DirectedEdge.new(v2, v3)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "sorts three vertices without fixed order" do
    vertices = [v1, v2, v3]
    vertices.shuffle!
    solutions = [
      [v1.value, v3.value, v2.value],
      [v3.value, v1.value, v2.value],
    ]

    # Inward triangle
    DirectedEdge.new(v1, v2)
    DirectedEdge.new(v3, v2)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "sorts three vertices without fixed order" do
    vertices = [v1, v2, v3]
    vertices.shuffle!
    solutions = [
      [v1.value, v2.value, v3.value],
      [v1.value, v3.value, v2.value],
    ]

    # Outward triangle
    DirectedEdge.new(v1, v2)
    DirectedEdge.new(v1, v3)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "sorts four vertices without fixed order" do
    vertices = [v1, v2, v3, v4]
    vertices.shuffle!
    solutions = [
      [v1.value, v2.value, v3.value, v4.value],
      [v1.value, v3.value, v2.value, v4.value],
    ]

    # Diamond
    DirectedEdge.new(v1, v2)
    DirectedEdge.new(v1, v3)
    DirectedEdge.new(v2, v4)
    DirectedEdge.new(v3, v4)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "sorts four vertices with fixed order" do
    vertices = [v1, v2, v3, v4]
    vertices.shuffle!
    solutions = [
      [v1.value, v3.value, v2.value, v4.value],
    ]

    # Diamond with diagonal
    DirectedEdge.new(v1, v2)
    DirectedEdge.new(v1, v3)
    DirectedEdge.new(v3, v2)
    DirectedEdge.new(v2, v4)
    DirectedEdge.new(v3, v4)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "sorts four vertices with fixed order and irrelevant edge" do
    vertices = [v1, v2, v3, v4]
    vertices.shuffle!
    solutions = [
      [v1.value, v3.value, v2.value, v4.value],
    ]

    # Diamond with diagonal
    DirectedEdge.new(v1, v2)
    DirectedEdge.new(v1, v3)
    DirectedEdge.new(v3, v2)
    DirectedEdge.new(v2, v4)
    DirectedEdge.new(v3, v4)
    DirectedEdge.new(v1, v4)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "sorts four vertices in diamond with final triangle" do
    vertices = [v1, v2, v3, v4, v5, v6]
    vertices.shuffle!
    solutions = [
      [v1.value, v3.value, v2.value, v4.value, v5.value, v6.value],
      [v1.value, v3.value, v2.value, v4.value, v6.value, v5.value],
    ]

    # Diamond with final triangle
    DirectedEdge.new(v1, v2)
    DirectedEdge.new(v1, v3)
    DirectedEdge.new(v3, v2)
    DirectedEdge.new(v2, v4)
    DirectedEdge.new(v3, v4)

    DirectedEdge.new(v4, v5)
    DirectedEdge.new(v4, v6)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "handles a disconnected graph" do
    vertices = [v1, v2, v3, v4]
    vertices.shuffle!
    solutions = [
      [v1.value, v2.value, v3.value, v4.value],
      [v1.value, v3.value, v2.value, v4.value],
      [v1.value, v3.value, v4.value, v2.value],
      [v3.value, v1.value, v2.value, v4.value],
      [v3.value, v1.value, v4.value, v2.value],
      [v3.value, v4.value, v1.value, v2.value],
    ]

    # Two one-step dependencies.
    DirectedEdge.new(v1, v2)
    DirectedEdge.new(v3, v4)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "detects when cycle exists" do
    vertices = [v1, v2, v3]
    vertices.shuffle!

    # Cycle
    DirectedEdge.new(v1, v2)
    DirectedEdge.new(v2, v3)
    DirectedEdge.new(v3, v1)
    (expect do
      topological_sort(vertices)
    end).to raise_error('graph contains cycle')
  end

  it "detects when a trickier cycle exists" do
    vertices = [v1, v2, v3, v4]
    vertices.shuffle!

    # Cycle
    DirectedEdge.new(v1, v2)
    DirectedEdge.new(v2, v3)
    DirectedEdge.new(v3, v4)
    DirectedEdge.new(v4, v2)

    (expect do
      topological_sort(vertices)
    end).to raise_error('graph contains cycle')
  end
end
