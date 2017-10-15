# Algorithms

## Dynamic Programming

Dynamic programming is not an algorithm; rather, it is a method of approaching a problem. Dynamic programming can be used whenever a problem exhibits _overlapping subproblems_, or _optimal substructure_, where to calculate the answer to a problem often in a solution you would have to calculate the same number twice.

One example is the following recursive definition of the nth Fibonacci number:

```cpp
int fib1(int n) {
  if (n < 0) throw domain_error("Input value out of range");

  // ternary operator; returns 1 if n == 0 or n == 1
  return (n < 2 ? 1 : fib1(n-1) + fib1(n-2));
}
```

When $$n = 2$$, this only has to call fibonacci\(0\) and fibonacci\(1\):

```
      2
     / \
    0   1
```

However, when $$n = 4$$, this has to call the following:

```
         4
        / \
       /   \
      2     3
     / \   / \
    0   1 1   2
             / \
            0   1
```

As should be obvious from the diagram, many functions are called more times than necessary. While in this small case it does not matter much, in larger algorithms it can be extremely significant if the same solution is calculated multiple times.

The way to solve this is through _caching_. This is the basic premise of dynamic programming.

```cpp
int cache[100005]; // initialised to 0
int fib2(int n) {
  if (n < 0) throw domain_error("Input value out of range");

  // we can do this because cache[n] is only zero
  // if it hasn't been calculated yet; no fibonacci
  // number is zero
  if (cache[n]) return cache[n];

  return cache[n] = (n < 2 ? 1 : fib2(n-1) + fib2(n-2));
}
```

This means we only have to call the following:

```
         4
        / \
       /   \
      2     3
     / \   / \
    0   1 1   2
```

`fib2(1)` and `fib2(2)` take very minimal time to compute the second time they are called, simply returning elements of an array. Therefore we have cut the runtime in half, and the improvement is much more dramatic for larger values of n.

**ASIDE**: To illustrate this graphically, I set up a debug version of the above programs which prints the number being passed as an argument and indents it. Here's the code:

```cpp
#include <bits/stdc++.h>

using namespace std;

int fib1(int n) {
  if (n < 0) throw domain_error("Input value out of range");

  // graphical representation
  for (int i=0; i<n; ++i) printf(" ");
  printf("%d\n",n);

  return (n < 2 ? 1 : fib1(n-1) + fib1(n-2));
}

int cache[100005]; // initialised to 0
int fib2(int n) {
  if (n < 0) throw domain_error("Input value out of range");
  if (cache[n]) return cache[n];

  // graphical representation
  for (int i=0; i<n; ++i) printf(" ");
  printf("%d\n",n);

  return cache[n] = (n < 2 ? 1 : fib2(n-1) + fib2(n-2));
}

int main(int argc, char* argv[]) {
  printf("fib1(4): %d\n", fib1(4));
  printf("fib2(4): %d\n", fib2(4));
}
```

The output produced is this:

```
    4
   3
  2
 1
0
 1
  2
 1
0
fib1(4): 5
    4
   3
  2
 1
0
fib2(4): 5
```

As you can see, the function `fib1` is called repeatedly with smaller numbers: `fib1(0)` and `fib1(2)` are called twice each and `fib1(1)` is called three times.

However, the function `fib2` only needs to calculate the values once each; the rest of the time the stored cached values are used.

The difference is minimal here; to illustrate it better, I tried running it with N=10.

```
[177 lines omitted]
fib1(10): 89
          10
         9
        8
       7
      6
     5
    4
   3
  2
 1
0
fib2(10): 89
```

This example much more clearly illustrates how much of an improvement a function using caching is.

## Shortest path

The shortest path problem involves finding the shortest path between two nodes on a graph; a number of variants exist such as restricting the graph to being directed and acyclic, or finding the shortest distance between all nodes on a graph. The most common algorithm is Dijkstra's algorithm, which finds the shortest path between two nodes on a directed graph with no negative edge weights \(it can easily be extended to undirected graphs.\)

### Dijkstra's Algorithm

#### Summary

Finds the shortest path between two nodes on a graph.

Can be quite easily modified to find the shortest path from a node to every other node in a graph.

#### Complexity

$$O(E log V)$$ where $$E$$ is the number of edges and $$V$$ is the number of vertices.

#### Code

```cpp
#include <bits/stdc++.h>

using namespace std;

typedef pair<int,int> pi;
const int INF       = 100000000;
const int MAX_NODES =    100000;

// Adjacency list.
// Pairs are formatted as {dist,node}
// rather than {node,dist}.
vector<pi> graph[MAX_NODES];

int dist[MAX_NODES];

int dijkstra(int s, int t, int num_nodes) {
  // s is start, t is destination

  // sort the nodes by distance
  priority_queue<pi, vector<pi>, greater<pi>> active;

  // if this function is going to be called
  // multiple times, dist must be reset
  // each time.
  for (int i=0; i<num_nodes; ++i) dist[i] = INF;

  dist[s] = 0;
  active.push({0,s});

  while (!active.empty()) {
    pi top = active.top();
    active.pop();

    // if it's not the newest version in the pq: ignore it
    if (top.first != dist[top.second]) continue;

    int curr = top.second;

    // remove this line if you don't have
    // one specific target
    if (curr == t) return dist[curr];

    for (auto nxt : graph[curr]) {
      // nxt = {dist,node}
      if (dist[nxt.second] > dist[curr] + nxt.first) {
        dist[nxt.second] = dist[curr] + nxt.first;
        active.push({dist[nxt.second],nxt.second});
      }
    }
  }

  // there's no path :(
  return INF;
}
```

#### Requirements

A graph with no negative cycles \(i.e. cycles with a negative length.\) The algorithm assumes a directed graph, and an undirected graph can easily be used as well by changing each edge of the graph to two directed edges with the same weight and opposite directions, i.e. `1 -- 2` becomes `1 -> 2` and `2 -> 1`.

#### Tips

The code assumes the graph is in [adjacency list](/chapter3/graphtheory.md#adjacency-list) format.

The code only calculates distances, not the nodes visited; it is relatively easy to backtrack the path, by storing the node that each node came from, i.e. when updating a node's minimum distance, update a pointer to the previously visited node.

### Floyd-Warshall

#### Summary

The Floyd-Warshall algorithm is an algorithm which finds the shortest distance between every pair of vertices in a graph.

#### Complexity

$$O(V^3)$$.

#### Code

```cpp
#include <bits/stdc++.h>

using namespace std;

const int MAX_NODES = 1005;
const int INF  = 100000000;

// adjacency matrix
int graph[MAX_NODES][MAX_NODES];
// the resulting distance
// dist[i][j] = distance from i to j
int  dist[MAX_NODES][MAX_NODES];

void floydwarshall(int num_nodes) {
  for (int i=0; i<num_nodes; ++i) {
    for (int j=0; j<num_nodes; ++j) {
      dist[i][j] = graph[i][j];
    }
  }

  for (int k=0; k<num_nodes; ++k) {
    for (int i=0; i<num_nodes; ++i) {
      for (int j=0; j<num_nodes; ++j) {
        dist[i][j] = min(dist[i][j],
                         dist[i][k]+dist[k][j]);
      }
    }
  }
}
```

#### Requirements

Same as Dijkstra.

#### Tips

The code above assumes the graph is in [adjacency matrix](/chapter3/graphtheory.md#adjacency-matrix) format.

## Minimum spanning tree

See the [section](/chapter3/graphtheory.md#minimum-spanning-tree) on Graph Theory.

### Prim's Algorithm

#### Summary

Prim's Algorithm is a greedy algorithm which finds the minimum spanning tree of a weighted undirected graph by choosing the lowest-cost edge from any vertex currently in the minimum spanning tree at any point.

#### Complexity

$$O(E log V)$$.

#### Pseudocode

```
- Need algorithm header for greater<>

- graph[i][j] represents the j-th outgoing edge from the i-th node
- represented in format {node, dist} i.e. if there was an edge from 0
- to 1 with length 3, and this was the only edge, graph[0][0] = {1,3}.
function prim takes an array of vectors of pairs graph as input:
  priority queue of pairs of integers with underlying storage vector of pairs
  and comparison function greater of pairs queue
  - priority_queue<pair<int,int>, vector<pair<int,int>>,
                                  greater<pair<int,int>>> queue;

  // It doesn't matter which vertex the source is.
  integer source = 0

  vector of integers weights of size graph size defaulting to INFINITY
  - vector<int> weights(graph size, INFINITY);

  vector of integers parent of size graph size defaulting to -1, representing a
  - nonexistent node
  - vector<int> parent(graph size, -1);

  vector of booleans visited of size graph size
  - vector<bool> visited(graph size, false);

  queue.push( {0, source} )
  weights[source] = 0

  while (!queue.empty()):
    integer vert = queue.top().second
    queue.pop()

    visited[vert] = true

    for i in graph[vert]:
      integer next = i.first
      integer dist = i.second

      if (!visited[next] && weights[next] > dist):
        weights[next] = dist
        queue.push( {weights[next], next} )
        parent[next] = vert

  for i in range 1 to the size of graph:
    - This prints every edge of the MST
    print parent[i], i
```

#### Requirements

A weighted undirected graph.  
In its most basic form, shown here, it only finds the MST of a connected graph.  
The algorithm here assumes the input is given as an adjacency list; this is more efficient than the implementation for an adjacency matrix.

#### Tips

The vectors can be replaced quite simply with arrays, assuming you know the maximum size of the graph. Use a for loop to initialise every value to infinity if using this method.

While the above function prints every edge of the MST, it can easily be modified to store these in a list of pairs of integers. Keep in mind that by definition an MST has $V-1$ edges, where $V$ is the number of vertices in the graph.

### Kruskal's Algorithm

#### Summary

A greedy algorithm for finding the minimum spanning tree of a graph. Essentially works by continually adding the smallest edge to the MST, and then removing it again if it would result in a cycle.

#### Complexity

$$O(E log V)$$.

#### Pseudocode

```
- Add all the Disjoint set implementation here


- graph is an edge list:
- {weight, {from, to}}
function kruskal takes vector of pairs of (int, pair of ints) graph as input:
  integer weight = 0       - of MST
  sort(graph.begin(), graph.end())

  - Using the function names from the Disjoint set pseudocode above
  create(graph size)

  for i in graph:
    integer groupa = find(i.second.first)
    integer groupb = find(i.second.second)

    if groupa != groupb:   - they do not create a cycle
      print u, v

      weight += i.first    - the weight of the edge

      union(groupa, groupb)


  return weight
```

#### Requirements

A weighted undirected graph.  
This algorithm can find the MST of a disconnected graph.  
This assumes input is given in _edge list_ format. This is similar to an adjacency list but every edge is stored separately, and it is trivial to convert between the two. See the pseudocode for the format it is stored in.

### Tips

While the above function prints every edge of the MST, it can easily be modified to store these in a list of pairs of integers. Keep in mind that by definition an MST has $$V-1$$ edges, where $$V$$ is the number of vertices in the graph.

## Convex Hull Trick

This could also be classified as a data structure. This essentially involves finding the minimum \(sometimes maximum\) y-value of a group of linear functions at any x value. The example given here \([http://wcipeg.com/wiki/Convex\_hull\_trick](http://wcipeg.com/wiki/Convex_hull_trick)\) is of four functions: $$y=4, y=4/3 + 2/3x, y=12-3x, y=3-1/2x$$. If the query was $$x=1$$, the answer would be the value $$2$$, with the function $$y=4/3+2/3x$$.

The naive approach is $$O(MQ)$$, with $$M$$ lines and $$Q$$ queries. The trick enables us to increase this to a speed of $$O((Q+M) log M)$$. The space required is $$O(M)$$, and the construction time is $$O(M log M)$$.

In the example given above, we first note that $$y=4$$ will never be the lowest. The trick is to find the intervals at which each line is the minimum and binary search these intervals to answer each query, of course after removing irrelevant lines such as $$y=4$$.

It is significant to note that each line that we add must only be compared with the two lines before it.

The below code assumes all the lines are added initially; there are variants which allow for logarithmic arbitrary line insertion.

```
long M[MAX_LINES]
long C[MAX_LINES]
integer length
integer pointer

- This function assumes that m descends. If all the input is given prior to
- runtime this is fine - just sort the input descending.
function addline takes integers m, c as input:
  - The intersection of the line represented by M[length-2], C[length-2] and
  - M[length-1], C[length-1] must be to the left of the intersection of M[length-1],
  - C[length-1] with m, c.
  while length >= 2 and (C[length-2]-C[length-1])*(m-M[length-1]) >=
                        (C[length-1]-c)*(M[length-1]-M[length-2]):
    length--

  M[length] = m
  C[length] = c
  length++

function minValue takes integer x as input:
  - Given ascending values of x
  pointer = min(pointer, length-1)

  while (pointer+1) < length and M[pointer+1]*x+C[pointer+1] <=
                                 M[pointer]*x+C[pointer]:
    pointer++

  return M[pointer]*x + C[pointer]
```

## Range minimum query

\(Variants include finding the sum of a range, the product of a range, the max of a range etc.\)

A range minimum query entails finding the minimum value in an array between indices $$L$$ and $$R$$. The naïve approach is to iterate over every value, which takes $$O(N)$$ time. Therefore we are only interested in algorithms that take $$< O(N)$$ time.

A range minimum query is best performed with one of the Range Tree, Prefix Sum and Sparse Table data structures. \(Each of these have requirements; see the _Data Structures_ section.\)

One alternative to Sparse Tables and Prefix Sums are Square Root Decompositions, which are good because they are quick to implement and have reasonably quick $$O(\sqrt{n})$$ query for $$O(\sqrt{n})$$ space complexity \(as well as $$O(\sqrt{n})$$ update and $$O(n)$$ preprocessing.\) In most cases a sparse table is a better option however, or, if updates are needed, a range tree is probably best.

A Square Root Decomposition works by dividing the array into $$\sqrt{n}$$ blocks of size $$\sqrt{n}$$ each. Square Root Decompositions work for any associative operators.

Query: Calculate the 'product' of each of the buckets in the preprocessed array which are contained entirely within the query range, linearly scan elements that are only partially within the buckets.

### With range updates

If we need to query ranges and update a range with operations such as 'set everything in this range to $$0$$' or 'multiply everything in this range by $$a$$', we can use a modified range tree. This is known as a 'lazy update range tree'. For the latter case, you would store a 'multiplication factor' for each node that was entirely contained within the range. This could be done by traversing up through the tree, changing every node's multiplication factor accordingly if they were a part of the range. This is only $$O(log N)$$.

This solution works with any pair of distributive semigroups. Since multiplication distributes over addition, the above solution works. Another example is that addition distributes over $$min$$, so the solution would work if we stored an amount to be added on each node and our queries were of the minimum element in a range.

## Lowest Common Ancestor

The Lowest Common Ancestor of two nodes in a tree is the lowest node on a tree which is an ancestor of both of them.

The naïve method of computing the LCA of two nodes involves determining every ancestor of each of the node and selecting the lowest one which is common to both of them.

### Reduction to RMQ

The Lowest Common Ancestor problem can be reduced to Range Minimum Query using the following method \(sourced from [https://www.topcoder.com/community/data-science/data-science-tutorials/range-minimum-query-and-lowest-common-ancestor/\#Another%20easy%20solution%20in%20O\(N%20logN,%20O\(logN\)](https://www.topcoder.com/community/data-science/data-science-tutorials/range-minimum-query-and-lowest-common-ancestor/#Another easy solution in O%28N logN, O%28logN%29)\).

Construct three arrays, `E`, `L` and `H`. `E` contains the nodes visited in an 'Euler Tour' of the tree, in order, and `E[i]` contains the index of the `i`th node visited in the tour. To construct this array, we start from the root node, and perform a DFS. Every vertex is added every time we visit it: that is, it is added to the array `E` when we descend from its parent, and when we return from it back to its parent. The array `E` will always have size $$2V - 1$$.

`L` contains the levels of the nodes visited in the Euler tour. The level, or height, is defined as the shortest distance to the root, so the root node will have height 0 \(or 1, depending on how you wish to define it\); the root's children will have height 1; and so on.

`H` is an array containing the index of any occurrence of each node in the array `E`. The actual occurrence is irrelevant so usually the first is used. In other words, `H[i]` contains the index of the first occurrence of node `i` in the array `E`.

To perform a query for nodes `u` and `v`, we first assume that `H[u]` is less than `H[v]`. If this is not true, it is trivial to swap `u` and `v`. Now, we find the index of the smallest level of nodes between `u` and `v`. In other words, we find the index of the minimum value in range \[`u`, `v`\] in the array `L`, using RMQ. Call this index `i`. The solution is then equal to `E[i]`.

# Knapsack

### Summary

Refers to any of a group of problems in which a set of items each with weights and values have to be packed into a knapsack such that the sum of their weights is less than or equal to the capacity of the knapsack and their value is as high as possible.

### Unbounded

There are no constraints; each item can be taken as many times as desired.

**Complexity:** $$O(NW,W)$$

**Potential Optimisations:**

* Divide all of the weights by their greatest common divisor to reduce space / complexity. Should be unnecessary in most cases

**Pseudocode:**  
$$w$$: amount of storage in knapsack  
$$n$$: number of items  
$$vals$$: values of items  
$$weights$$: weights of items

```
Create an array 'dp' of length w+1
- dp[i] represents the highest
- possible score with a weight of
- less than or equal to i.

Initialise every element of dp to 0

for i in range 0 to w+1:
  for j in range 0 to n:
    - See if this item can be taken
    - to improve on our score
    if i+weights[j] < w+1:
      - We can take this item
      dp[i+vals[j]] = max(
        dp[i+vals[j]],
        dp[i]+vals[i]
        )
```

### 0/1 \(Binary\)

Each item can be taken at most once.

**Complexity:** $$O(NW,NW)$$

**Potential Optimisations:**  
'Flatten' the array, storing only one one-dimensional array of length W+1 and rewriting from indexes W to 1 each time, giving the same result for $$O(W)$$ space.  
There is another approach commonly named "meet-in-the-middle" which uses $$O(2^{\frac{n}{2}})$$ space and $$O(n \cdot 2^{\frac{n}{2}})$$ runtime. It may be more optimal for very large values of W.  
It works as follows:

* partition the set of items into two sets of approximately equal size&lt;/li&gt;
* find the weights and values of the subsets of each set&lt;/li&gt;
* for each subset of the first set:
  find the subset of the second set of greatest value such that their combined weight is less than W
* keep track of the greatest value so far

We can optimise this algorithm to the aformentioned $$O(n \cdot 2^{\frac{n}{2}})$$ runtime by sorting subsets of the second set by weight, discarding those which weigh more than those of greater / equal value, and using binary search.

**Pseudocode:**  
$$w$$: amount of storage in knapsack  
$$n$$: number of items  
$$vals$$: values of items  
$$weights$$: weights of items

```
Create an array 'dp' of size n+1 by w+1
- dp[i][j] represents the maximum
- possible value that can be achieved
- using only the first i items
- up to weight j.

for j in range 0 to w+1:
  dp[0][j] = 0

for i in range 0 to n:
  for j in range 0 to w:
    if weights[i] > j:
      dp[i+1][j] = dp[i][j]
    else:
      dp[i+1][j] = max(
        dp[i][j],
        dp[i][j-weights[i+1]]+vals[i+1]
        )
```

## Topological Sort

A topological sort of a graph is an ordering of vertices in a directed \(acyclic\) graph such that, for every edge, the source vertex is guaranteed to be before the destination vertex in the topological sort. \(There may be multiple topological sorts of a graph.\)

Another way of thinking about it is that, if a number of vertices are processed in order of their topological sort, then each vertex is guaranteed that the vertices with edges going into it have already been processed.

Topological sorting obviously only works on directed, acyclic graphs.

Here's an algorithm to find a topological sorting of a graph. It requires the graph to be in adjacency list format.

```cpp
#include <bits/stdc++.h>

using namespace std;

bool seen[MAX_NODES];
vector<int> graph[MAX_NODES];

vector<int> topoSort;

void DFS(int c) {
  if (seen[c]) return;
  seen[c]=true;
  for (int n : graph[c]) {
    DFS(n);
  }
  topoSort.push_back(c);
}

// n is the number of nodes
void calculateTopoSort(int n) {
  for (int i=0; i<n; ++i) {
    DFS(i);
  }
  reverse(topoSort.begin(), topoSort.end());
}
```

## Cycle Compression

This involves compressing cycles in an undirected graph into single nodes, so that the resulting graph is a tree \(or a forest, if the original graph was disconnected\).

The definition of 'cycle' here is a maximal subgraph of an undirected graph that does not contain any bridge edges. A bridge edge is an edge that, if it is removed, increases the number of connected components of a graph by one. Thus, the compressed graph's edges all correspond to bridge edges in the original graph.

Information may be stored for each node in the compressed graph: for instance, how many nodes in the original graph are represented by the compressed node \(which is what is given in this case\) or which nodes are corresponded to. The code given here implements the first of these.

This algorithm is $$O(V + E)$$.

```cpp
#include <bits/stdc++.h>

using namespace std;

// Disjoint set
const int MAX_NODES = 100000;

int parent[MAX_NODES+1];
int  nrank[MAX_NODES+1];

void create(int n) {
  for(int i=0;i<=n;++i)parent[i]=i;
}

int find(int x) {
  return parent[x]=parent[x]^x?find(parent[x]):x;
}

void join(int x, int y) {
  x=find(x);y=find(y);
  nrank[x]>nrank[y]?parent[y]=x:parent[x]=y;
  nrank[y]+=nrank[x]==nrank[y];
}

// color is 0 for unvisited nodes,
// 1 for nodes currently being visited,
// 2 for nodes which have already been fully visited.
int color[MAX_NODES];

// parent of a node in the DFS.
// This should be initialised to
// UNINITIALISED.
const int UNINITIALISED = -1;
int dfs_parent[MAX_NODES];

// whether or not this node has
// been merged. if this is true,
// we don't have to worry about
bool merged[MAX_NODES];

// represents the number of nodes
// in the original graph that this
// node represents. if this is 0, the
// node doesn't actually exist.
int numNodes[MAX_NODES];

// Adjacency list for the graph
vector<int> graph[MAX_NODES];

void DFS(int c) {
  if (color[c] == 1) {
    // There is a cycle.
    // We keep going up through
    // our parents until we hit
    // one that is either merged,
    // or this one. We merge
    // with each of these.
    merged[c] = true;

    int nxt = dfs_parent[c];
    while (!merged[nxt] && nxt != c) {
      join(nxt, c);
      merged[nxt] = true;
      nxt = dfs_parent[c];
    }
    join(nxt, c); // just in case
    merged[nxt] = true;

    return;
  }

  color[c] = 1;

  for (int nxt : graph[c]) {
    if (dfs_parent[nxt] == UNINITIALISED) {
      dfs_parent[nxt] = c;
    }

    DFS(nxt);
  }

  // We've finished visiting.
  color[c] = 2;
}

// call create(n) before DFS,
// and initialise dfs_parent to UNINITIALISED.

// ... call DFS ...

for (int i = 0; i < n; ++i) {
  // modify this node's outgoing edges
  // to point to the representative nodes
  for (int j = 0; j < graph[i].size(); ++j) {
    graph[i][j] = find(graph[i][j]);
  }

  int newPos = find(i);
  numNodes[newPos]++;
  if (newPos ^ i) {
    // move this node's edges
    // to the new, 'representative'
    // node
    for (int nxt : graph[i]) {
      if (nxt != newPos) {
        graph[newPos].push_back(nxt);
      }
    }
    graph[i].clear();
  }
}
```



