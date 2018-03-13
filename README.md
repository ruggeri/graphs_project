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

**Big idea:** You do DFS until you hit a vertex with no children,
pushing parent vertices onto the stack along the way. When you hit a
vertex with no children, you add this vertex to the result and pop back
up. If when you pop up you hit a vertex where all its children have
been added to the result, you can pop that and add it. Otherwise you
have to process the children of that parent vertex.

**Details:** We will use an explicit `stack`. We will not use
recursion. Start out by iterating the vertices, pushing those with no
in edges onto the stack.

Now, we loop until the stack is empty. Each time, peek at the top
vertex and go through each of its children. If all children are
already in the result array, pop the vertex and add it to the result
array.

Else, push each child that is not in the result array already onto the
stack.

**Tarjan Problem #1**

There are two possible problems. First, what if the top vertex is
already added to the result? For instance:

```
A => B
A => C
C => B
C => D
```

Consider the run:

```
Push A
Push B
Push C
Push B
Push D
```

Notice that `B` is pushed twice. That is okay and inevitable. You must
push `B` that second time, otherwise you would not list it before `C`.

The solution is that when you peek at `B` the first pushed `B` (after
having added the second pushed `B` to the result), you should just pop
the first pushed `B` and skip it without adding it again.

Thus the solution is to not add a vertex to the result if it is already
in the result.

**Tarjan Problem #2**

The other problem has to do with infinite looping:

```
A => B
B => C
C => A
```

results in:

```
Push A
Push B
Push C
Push A
Push B
Push C
...
```

You need to detect when this happens. You might assume that the correct
solution is to check if a vertex is already in the stack, and then
raise an error if we try to push it on again.

However, the prior example shows a scenario where we *do* want to
push the same vertex `B` twice. In the prior example we need to push it
the second time so that `B` is added to the result before `C`.

Here is the difference. In the cyclic example, we start processing A's
children, and as part of that we start processing B's children, and
as part of that we start processing C's children, which includes A.

In the first example, we start processing A's children (adding B and
C), then start processing C's children (which is just B), and then we
start processing B's children (there are none). This second time we
push B is different, because we are not "in the middle" of processing
B from before, we are in the middle of processing *C*.

The solution is to keep a second stack of "active" vertices we are in
the middle of processing. Each time we add a vertices children, we
should mark that parent vertex as "active." If we ever try to
add an active vertex onto the stack a second time, we know we hit a
loop.

Each time we pop a vertex and push it into the result because we have
finished processing all of its children, we should also mark it as
inactive.
