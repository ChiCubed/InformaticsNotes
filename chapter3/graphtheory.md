# Graph Theory
## Representing a graph
### Adjacency matrix
Stores the distance between any two vertices, i.e.:
`graph[i][j]` is the distance between vertices `i` and `j`. If there is no edge between two vertices a value representing inifinity can be used, and there is obviously $$0$$ distance from a vertex to itself.

$$O(V^2)$$ space.

### Adjacency list
Stores the distance from every vertex to every vertex it has an edge to, i.e.
`graph[i][j]` represents the `j`th outgoing edge from vertex `i`.

$$O(EV)$$ space. Typically much less; normally one would use a list of vectors to represent the outgoing edges, to account for sparse and dense graphs alike.

### Conversion
```cpp
#include <bits/stdc++.h>

using namespace std;

// The following functions assume adjacency lists
// store edges in the format {dist, node}
// instead of what may seem more logical,
// {node, dist}. This is to allow the lists
// to be easily sorted.
// All indices are assumed to be 0-indexed.

// Obviously you don't have to use vectors,
// you can just use arrays that are large enough.
// With adjacency lists, I would recommend that you
// use an array of vector<pair<int,int>>
// rather than a 2d array of pairs of integers
// because in dense graphs this can waste a lot
// of space.

const int INF = 100000000;

typedef pair<int,int> pi;
typedef vector<vector<pi>> adjlist_t;
typedef vector<vector<int>> adjmat_t;

adjlist_t matrixToList(adjmat_t matrix) {
  adjlist_t list;
  // for every pair of nodes
  for (int i=0; i<matrix.size(); ++i) {
    list.push_back({});
    for (int j=0; j<matrix[i].size(); ++j) {
      if (i!=j && matrix[i][j] != INF) {
        // there is an edge from i to j
        list[i].push_back({matrix[i][j],j});
      }
    }
  }
  
  return list;
}

// nodes represents the number of nodes in the graph
adjmat_t listToMatrix(adjlist_t list, int nodes) {
  adjmat_t matrix;
  
  // build the adjacency matrix
  for (int i=0; i<nodes; ++i) {
    matrix.push_back({});
    for (int j=0; j<nodes; ++j) {
      matrix[i].push_back(INF);
    }
  }
  
  for (int i=0; i<nodes; ++i) {
    matrix[i][i]=0;
    for (auto j : list[i]) {
      // sanity check
      if (j.second >= nodes) continue;
      
      matrix[i][j.second] = j.first;
    }
  }
  
  return matrix;
}
```

[Hey look a test](#tree)

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