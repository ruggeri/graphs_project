require_relative '00_directed_graph'

# Implementing topological sort using Kahn's algorithm.

def topological_sort(vertices)
  in_edge_counts = {}
  queue = []
  vertices.each do |v|
    in_edge_count = v.in_edges.count
    in_edge_counts[v] = in_edge_count
    queue << v if in_edge_count == 0
  end

  result = []
  until queue.empty?
    v = queue.shift
    result << v

    v.out_edges.each do |e|
      in_edge_counts[e.to_vertex] -= 1
      queue << e.to_vertex if in_edge_counts[e.to_vertex] == 0
    end
  end

  raise 'graph contains cycle' if result.count < vertices.count
  result
end

# Bonus: Implement topo sort with Tarjan's DFS algorithm. Do this
# *after* implementing Prim's algorithm.

# def topological_sort_(vertex, result, added_to_result, active_path)
#   active_path[vertex] = true
#
#   vertex.out_edges.each do |e|
#     to_vertex = e.to_vertex
#     next if added_to_result[to_vertex]
#     raise 'graph contains cycle' if active_path[to_vertex]
#
#     topological_sort_(to_vertex, result, added_to_result, active_path)
#   end
#
#   result << vertex
#   added_to_result[vertex] = true
#   active_path[vertex] = false
#
#   nil
# end
#
# def topological_sort(vertices)
#   result = []
#   added_to_result = {}
#   active_path = {}
#
#   vertices.each do |v|
#     if v.in_edges.count == 0
#       topological_sort_(v, result, added_to_result, active_path)
#     end
#   end
#
#   raise 'graph contains cycle' if result.count < vertices.count
#   result.reverse!
#   result
# end
