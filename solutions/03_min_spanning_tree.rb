require '01_undirected_graph'

def prims_algorithm(vertices)
  start_vertex = vertices[0]

  result = []

  visited_vertices = {
    start_vertex => true
  }
  fringe = {}

  start_vertex.edges.each do |e|
    fringe[e.other_vertex(start_vertex)] = e
  end

  until fringe.empty?
    vertex, edge = fringe.min_by { |vertex, edge| edge.cost }

    result << edge
    visited_vertices[vertex] = true
    fringe.delete vertex

    vertex.edges.each do |e|
      other_vertex = e.other_vertex(vertex)
      next if visited_vertices[other_vertex]

      current_edge = fringe[other_vertex]
      next if current_edge && current_edge.cost < e.cost
      fringe[other_vertex] = e
    end
  end

  return nil if result.count < (vertices.count - 1)
  result
end
