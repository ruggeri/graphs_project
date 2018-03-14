## 00: DirectedVertex, DirectedEdge

* Implement versions of vertex and edge which have a notion of
  `to_edges` and `out_edges`

## 01: UndirectedVertex, UndirectedEdge

* Repeat, but with for an undirected graph where all edges are
  bidirectional.
* The `#other_edge` method is a handy way to get the other side of an
  edge. Otherwise it's hard to get all the neighbors of a vertex.

## 02: Topological Sort: Kahn Style

**Important:** For these topo sort exercises, we want to list parents
before children. This is the *opposite* of a typical dependency graph.
For instance, if `A => B => C`, we want to list `[A, B, C]` not
`[C, B, A]`.

**Big Idea:**: The basic idea is to keep a hash map of in edge
counts. Whenever a vertex has no more in edges, put it the result
array. Then update the hash map by decrementing the in edge count of
all downstream edges.

**Details:** At the start, build the hash map of in edge counts. Also
keep a queue of vertices that start out with no in edges.

One by one, shift from the queue. Each time you remove a vertex,
put it in the result array. Also, for each out edge, decrement the count
of in edges for the descendent vertex. If that count hits zero, push
the descendent vertex into the queue.

Continue until the queue is empty. If the result contains all the
vertices then good. Otherwise, there must be a cycle in the graph.

## 03: Prim's Algorithm

**Purpose:** Our goal is to find a set of `v - 1` edges that connect
the entire graph with the minimum total cost. This would be useful if
you wanted to build a railway network to connect all the cities of the
UK with minimal cost to the railroad company.

**Big Idea:** At each step, we will choose the lowest cost edge from
the set of previously visited vertices to the set of unvisited
vertices.

**Details:** To do this, start with any vertex. Add it to a set of
"visited" vertices. Consider every neighboring vertex. Add each to a
hash map that maps vertex to the edge that connects the start vertex
to the neighbor vertex. Call this map the `fringe`.

Now, iterate until the fringe is empty. Each time, select the vertex
and edge pair which have the minimum cost in the fringe. Add that edge
to your result array, and add that vertex to your visited vertices.

Consider each of the neighbors of this newly visited vertex. If they
have not been added to the fringe before, add them and the
corresponding edge. Else, check if the current edge is lower cost than
the previously stored edge. If so, change the edge stored for the
vertex.

## Bonus: Topological Sort: Tarjan Style

**Big idea:** You do DFS. At each vertex, you make sure all the
children are pushed into the result array before you push the parent
in. If a child has already been added to the result array, you should
skip re-processing it. Otherwise you must recurse.

DFS can enter an infinite cycle of loops. If you ever hit a vertex in
a deeper stack frame that you are currently processing in a higher up
stack frame, you must raise an error.

**Details:** Break the problem into two parts. `topological_sort_`
should work from a single root vertex. `topological_sort` should iterate
through the vertices and call `topological_sort_` on each vertex that
has no in edges.

`topological_sort_` needs four arguments:

1. A vertex.
2. The result array to push into.
3. A hash map called `added_to_result` to allow `O(1)` checking whether
   a vertex has been added to the result array. Why is
   `result.include?(vertex)` not ideal?
4. A hash map called `active_path` which records which vertices are
   currently being processed "on the stack."

In `topological_sort_`, the first thing you do is add the vertex to the
`active_path` since you are processing it.

Then, go through the out edges. If you have already added a child
vertex to the result you can move on. If you hit a child vertex that
is on the active path, why does this mean there is a cycle? Raise an
error in that case.

Else, call `topological_sort_` recursively on the child vertex to
process it and all its dependencies.

After processing all children, you may add the parent vertex to the
result. Make sure to record this in the hash map too.

Last, right before returning from `topological_sort_`, remove the
parent vertex from the active path hash. We are done processing it and
the stack frame is being popped.

## Bonus2: Topological Sort: Tarjan Style with Explicit Stack

Repeat the above, but without using recursion. Explicitly use a stack.
