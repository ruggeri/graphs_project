require '00_graph'

def prims_algorithm(vertices)
  start_vertex = vertices[0]

  result = []

  visited_vertices = {
    start_vertex => true
  }
  fringe = {}

  start_vertex.out_edges.each do |e|
    fringe[e.to_vertex] = e
  end

  until fringe.empty?
    vertex, edge = fringe.min_by { |vertex, edge| edge.cost }

    result << edge
    visited_vertices[vertex] = true
    fringe.delete vertex

    vertex.out_edges.each do |e|
      next if visited_vertices[e.to_vertex]

      current_edge = fringe[e.to_vertex]
      next if current_edge && current_edge.cost < e.cost
      fringe[e.to_vertex] = e
    end
  end

  return nil if result.count < (vertices.count - 1)
  result
end
