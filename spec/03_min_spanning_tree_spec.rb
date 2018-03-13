require 'rspec'
require '02_min_spanning_tree'

describe 'MinSpanningTree' do
  let(:ny) { Vertex.new("New York") }
  let(:sf) { Vertex.new("San Francisco") }
  let(:la) { Vertex.new("Los Angeles") }
  let(:chi) { Vertex.new("Chicago") }
  let(:sea) { Vertex.new("Seattle")}

  it "works on a trivial graph of two vertices" do
    vertices = [ny, sf]
    e = Edge.new(ny, sf, 123)

    expect(prims_algorithm(vertices)).to eq([e])
  end

  it "works on a trivial graph of three vertices" do
    vertices = [ny, sf, la]
    e = Edge.new(ny, sf, 123)
    e2 = Edge.new(sf, la, 123)

    expect(prims_algorithm(vertices)).to match_array([e, e2])
  end

  it "works on a cyclic graph of three vertices" do
    vertices = [ny, sf, la]

    e = Edge.new(ny, sf, 123)
    e2 = Edge.new(sf, la, 456)
    e3 = Edge.new(la, ny, 789)

    expect(prims_algorithm(vertices)).to match_array([e, e2])
  end

  it "works on a diamond graph with diagonal" do
    vertices = [ny, sf, la, chi]

    ny_sf = Edge.new(ny, sf, 1)
    ny_chi = Edge.new(ny, chi, 3)
    sf_chi = Edge.new(sf, chi, 2)
    sf_la = Edge.new(sf, la, 4)
    chi_la = Edge.new(chi, la, 5)

    expect(prims_algorithm(vertices)).to match_array([
      ny_sf,
      sf_chi,
      sf_la
    ])
  end

  it "works on a square with center graph" do
    vertices = [ny, sf, la, chi]

    # ny ==== chi
    #     la
    # sf ==== sea

    ny_la
    ny_chi
    ny_sf

    ny_sf = Edge.new(ny, sf, 1)
    ny_chi = Edge.new(ny, chi, 3)
    sf_chi = Edge.new(sf, chi, 2)
    sf_la = Edge.new(sf, la, 4)
    chi_la = Edge.new(chi, la, 5)

    expect(prims_algorithm(vertices)).to match_array([
      ny_sf,
      sf_chi,
      sf_la
    ])
  end
end
