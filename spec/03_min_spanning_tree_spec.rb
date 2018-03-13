require 'rspec'
require '03_min_spanning_tree'

describe 'MinSpanningTree' do
  let(:ny) { UndirectedVertex.new("New York") }
  let(:sf) { UndirectedVertex.new("San Francisco") }
  let(:la) { UndirectedVertex.new("Los Angeles") }
  let(:chi) { UndirectedVertex.new("Chicago") }
  let(:sea) { UndirectedVertex.new("Seattle")}

  it "works on a trivial graph of two vertices" do
    vertices = [ny, sf]
    e = UndirectedEdge.new(ny, sf, 123)

    expect(prims_algorithm(vertices)).to eq([e])
  end

  it "works on a trivial graph of three vertices" do
    vertices = [ny, sf, la]
    e = UndirectedEdge.new(ny, sf, 123)
    e2 = UndirectedEdge.new(sf, la, 123)

    expect(prims_algorithm(vertices)).to match_array([e, e2])
  end

  it "works on a cyclic graph of three vertices" do
    vertices = [ny, sf, la]

    e = UndirectedEdge.new(ny, sf, 123)
    e2 = UndirectedEdge.new(sf, la, 456)
    e3 = UndirectedEdge.new(la, ny, 789)

    expect(prims_algorithm(vertices)).to match_array([e, e2])
  end

  it "works on a diamond graph with diagonal" do
    vertices = [ny, sf, la, chi]

    ny_sf = UndirectedEdge.new(ny, sf, 1)
    ny_chi = UndirectedEdge.new(ny, chi, 3)
    sf_chi = UndirectedEdge.new(sf, chi, 2)
    sf_la = UndirectedEdge.new(sf, la, 4)
    chi_la = UndirectedEdge.new(chi, la, 5)

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

    ny_chi = UndirectedEdge.new(ny, chi, 1)
    ny_la = UndirectedEdge.new(ny, la, 2)
    sf_ny = UndirectedEdge.new(sf, ny, 7)
    sf_la = UndirectedEdge.new(sf, la, 6)
    la_chi = UndirectedEdge.new(la, chi, 5)
    la_sea = UndirectedEdge.new(la, sea, 4)
    chi_sea = UndirectedEdge.new(chi, sea, 3)

    expect(prims_algorithm(vertices)).to match_array([
      ny_chi,
      ny_la,
      chi_sea,
      sf_la
    ])
  end
end
