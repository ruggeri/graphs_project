class UndirectedVertex
  attr_reader :value, :edges

  def initialize(value)
    @value = value
    @edges = []
  end
end

class UndirectedEdge
  attr_reader :vertices, :cost

  def initialize(vertex1, vertex2, cost = 1)
    @vertices = [vertex1, vertex2]
    @cost = cost

    vertex1.edges << self
    vertex2.edges << self
  end

  def destroy!
    vertices[0].edges.delete(self)
    vertices[1].edges.delete(self)

    @vertices = nil
  end
end
