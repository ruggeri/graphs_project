require 'rspec'
require '01_topological_sort'

describe 'TopologicalSort' do
  let(:v1) { Vertex.new("Wash Markov") }
  let(:v2) { Vertex.new("Feed Markov") }
  let(:v3) { Vertex.new("Dry Markov") }
  let(:v4) { Vertex.new("Brush Markov") }
  let(:v5) { Vertex.new("Cuddle Markov") }
  let(:v6) { Vertex.new("Walk Markov") }
  let(:v7) { Vertex.new("Teach Markov") }
  let(:v8) { Vertex.new("Worship Markov") }

  it "sorts two vertices" do
    vertices = [v1, v2]
    vertices.shuffle!
    solutions = [
      [v1.value, v2.value],
    ]

    Edge.new(v1, v2)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "sorts three vertices" do
    vertices = [v1, v2, v3]
    vertices.shuffle!
    solutions = [
      [v1.value, v2.value, v3.value],
    ]

    # Linear order
    Edge.new(v1, v2)
    Edge.new(v2, v3)
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
    Edge.new(v1, v2)
    Edge.new(v3, v2)
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
    Edge.new(v1, v2)
    Edge.new(v1, v3)
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
    Edge.new(v1, v2)
    Edge.new(v1, v3)
    Edge.new(v2, v4)
    Edge.new(v3, v4)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "sorts four vertices with fixed order" do
    vertices = [v1, v2, v3, v4]
    vertices.shuffle!
    solutions = [
      [v1.value, v3.value, v2.value, v4.value],
    ]

    # Diamond with diagonal
    Edge.new(v1, v2)
    Edge.new(v1, v3)
    Edge.new(v3, v2)
    Edge.new(v2, v4)
    Edge.new(v3, v4)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "sorts four vertices with fixed order and irrelevant edge" do
    vertices = [v1, v2, v3, v4]
    vertices.shuffle!
    solutions = [
      [v1.value, v3.value, v2.value, v4.value],
    ]

    # Diamond with diagonal
    Edge.new(v1, v2)
    Edge.new(v1, v3)
    Edge.new(v3, v2)
    Edge.new(v2, v4)
    Edge.new(v3, v4)
    Edge.new(v1, v4)
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
    Edge.new(v1, v2)
    Edge.new(v1, v3)
    Edge.new(v3, v2)
    Edge.new(v2, v4)
    Edge.new(v3, v4)

    Edge.new(v4, v5)
    Edge.new(v4, v6)
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
    Edge.new(v1, v2)
    Edge.new(v3, v4)
    expect(solutions).to include(topological_sort(vertices).map{ |vert| vert.value})
  end

  it "detects when cycle exists" do
    vertices = [v1, v2, v3]
    vertices.shuffle!

    # Cycle
    Edge.new(v1, v2)
    Edge.new(v2, v3)
    Edge.new(v3, v1)
    expect(topological_sort(vertices)).to eq(nil)
  end

  it "detects when a trickier cycle exists" do
    vertices = [v1, v2, v3, v4]
    vertices.shuffle!

    # Cycle
    Edge.new(v1, v2)
    Edge.new(v2, v3)
    Edge.new(v3, v4)
    Edge.new(v4, v1)
    expect(topological_sort(vertices)).to eq(nil)
  end
end
