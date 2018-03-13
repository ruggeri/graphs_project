require_relative '00_graph'

# Implementing topological sort using both Khan's and Tarian's algorithms

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

  return nil if result.count < vertices.count
  result
end

# def topological_sort(vertices)
#   result = []
#   added_to_result = {}
#   stack = []
#   active_path = {}
#
#   vertices.each do |v|
#     if v.in_edges.count == 0
#       stack << v
#     end
#   end
#
#   until stack.empty?
#     v = stack.pop
#
#     next if added_to_result[v]
#
#     if v.out_edges.all? { |e| added_to_result[e.to_vertex] }
#       active_path.delete(v)
#
#       result << v
#       added_to_result[v] = true
#     else
#       stack << v
#       active_path[v] = true
#
#       v.out_edges.each do |e|
#         return nil if active_path[e.to_vertex]
#         stack << e.to_vertex
#       end
#     end
#   end
#
#   return nil if result.count < vertices.count
#   result.reverse!
#   result
# end
