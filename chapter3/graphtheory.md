# Graph Theory
## Representing a graph
### Adjacency matrix
Stores the distance between any two vertices, i.e.:
`graph[i][j]` is the distance between vertices `i` and `j`. If there is no edge between two vertices a value representing inifinity can be used, and there is obviously $$0$$ distance from a vertex to itself.

$$O(V^2)$$ space.

### Adjacency list
Stores the distance from every vertex to every vertex it has an edge to, i.e.
`graph[i][j]` represents the `j`th outgoing edge from vertex `i`.

$$O(EV)$$ space. Typically much less, if using vectors. Normally one would use a list of vectors to represent the outgoing edges, to account for sparse and dense graphs alike.

### Conversion
```
- The following functions assume adjacency lists
- store edges in the format {dist, node}
- instead of what may seem more logical,
- {node, dist}. This is to allow the lists
- to be easily sorted.

function matrixToList takes array of arrays graph:
  array of vectors of pairs result
  
  for i in range 0 to size of graph:
    for j in range 0 to size of graph:
      if i != j and graph[i][j] != INFINITY:
        result[i].push_back( {graph[i][j],j} )
  
  return result
  
function listToMatrix takes array of vectors of pairs graph:
  array of arrays result with default value INFINITY
  
  for i in range 0 to size of graph:
    - C++11 range-based for loop.
    - see the C++ tips section
    result[i][i] = 0
    for ( auto j : graph[i] ):
      result[i][j.second] = j.first
  
  return result
```

## Tree
An undirected graph in which any two vertices are connected by exactly one path.

A graph $$G$$ with $$n$$ vertices is a tree if: (Technically these are equivalent statements)

- $$G$$ is connected (i.e. no vertices have no edges) and $$G$$ is not connected if any edge is removed
- $$G$$ has no cycles, and a cycle is formed if any edge is added
- $$G$$ is connected and has $$n-1$$ edges
- $$G$$ has no cycles and has $$n-1$$ edges

## Minimum Spanning Tree
The minimum spanning tree of a graph is defined to be the tree with the smallest weight that connects every node in the graph. (It may not be unique.)

- Every MST has $$n-1$$ edges, where there are $$n$$ edges in the graph
- If every edge has a different weight the MST is unique
- The longest edge in any cycle cannot belong to an MST
- If the shortest edge in a graph is unique, that edge is in every MST of the graph