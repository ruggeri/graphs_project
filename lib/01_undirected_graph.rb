class UndirectedVertex
  # attr_reader ...

  def initialize(value)
  end
end

class UndirectedEdge
  # attr_reader ...

  def initialize(vertex1, vertex2, cost = 1)
  end

  def destroy!
  end

  def other_vertex(vertex)
  end
end
