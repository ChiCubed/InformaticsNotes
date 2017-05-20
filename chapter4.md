# Data Structures

## Range Tree

### Summary

A range tree allows querying the minimum / sum / product / other operations (see Requirements) of the range $$[L,R]$$ in an array in $$O(log N)$$ time. It is typically the best option for range queries, and its fast updates normally make it the best option for querying a range. There are a few exceptions; for example, when there are no updates and the operation you are using has a unique inverse, prefix tables are a better (and much faster) option; sparse tables can also be used in some cases.

A range tree essentially allows reduction of a query to a lowest common ancestor problem.

### Complexity

| Preprocessing | Query | Update | Space |
| :---: | :---: | :---: | :---: |
| $$O(N)$$ | $$O(log N)$$ | $$O(log N)$$ | $$O(N)$$ |

### Code

```cpp
#include <bits/stdc++.h>

using namespace std;

const int VERY_BIG_NUMBER = 1000000;
const int MAX_ARRAY_LENGTH = 100000;
const int INF           = 100000000;

int tree[VERY_BIG_NUMBER];
int arr[MAX_ARRAY_LENGTH];

// Helper function so we
// don't have to type the
// same thing over and over again.
inline int mid(int a, int b) {
  return ((a+b)>>1);
}

// Preprocess the array.
// Initially this is called as follows:
// preprocess(0, ARRAY_LENGTH - 1, 0)
// Returns the new minimum in range
// [l,r].
int preprocess(int l, int r, int pos) {
  // The children of the current node
  // (represented by pos)
  // are at indices 2*pos+1 and 2*pos+2.
  
  // Note we have used a single
  // equals sign. The default return
  // value of a=b is the result,
  // i.e. a=b returns b.
  // This is just for conciseness.
  if (l==r) return tree[pos]=arr[l];
  
  // In this example we are using
  // the min operation. We could
  // equally well have used sum or
  // any other associative operation.
  int m=mid(l,r);
  return tree[pos]=min(preprocess(l,  m,(pos<<1)+1),
                       preprocess(m+1,r,(pos<<1)+2));
}

// Returns the minimum in range [s,e].
// This should be called as follows:
// query(0, ARRAY_LENGTH - 1, 0, rangeStart, rangeEnd)
int query(int l, int r, int pos, int s, int e) {
  // If we're within the query range:
  // just return the minimum here
  if (s <= l && r <= e) return tree[pos];
  
  // If we're completely outside the query range:
  // return the identity of the operation.
  // Since the operation is min, the identity
  // in this case is INF.
  if (e < l || r < s) return INF;
  
  // We partially overlap the query range.
  int m=mid(l,r);
  return min(query(l,  m,(pos<<1)+1,s,e),
             query(m+1,r,(pos<<1)+2,s,e));
}

// Update the element at index i to value val.
// Returns the new value of a node.
int update(int l, int r, int pos, int i, int val) {
  // if the index to be updated is outside the range:
  // do nothing
  if (i < l || r < i) return tree[pos];
  
  // We're on a node at the bottom of the tree:
  // we update its value
  if (l==r) return tree[pos]=arr[l]=val;
  
  // We contain the index to update.
  int m=mid(l,r);
  return tree[pos]=min(update(l,  m,(pos<<1)+1,i,val),
                       update(m+1,r,(pos<<1)+2,i,val));
}
```

### Requirements

A range tree works on any associative operators.

Identities are not necessary if you implement a range tree differently, that is by returning a placeholder value if a node is out of range in the query function and checking for that placeholder being returned.

**ASIDE**: There _are_ actually associative operators without identities, although of course it is very unlikely these will turn up in an informatics competition.

## Prefix sum

### Summary

A prefix sum array is a data structure which stores the 'sum' of all of the operations up to an index. For example, if you wished to construct a prefix sum array on the array $$[1, 2, 3]$$ using addition as your operation, the prefix sum array would be $$[1, 1+2, 1+2+3]$$.

The name carries connotations of addition but a prefix sum array works on any operation that forms a group with its set $$S$$; see the Requirements section.

### Complexity

| Preprocessing | Query | Update | Space |
| :---: | :---: | :---: | :---: |
| $$O(N)$$ | $$O(inverse)$$\* | $$O(N)$$ | $$O(N)$$ |

\*$$inverse$$ is the cost of performing the inverse of whatever function you have chosen to perform. For example, if you have a prefix sum array using multiplication, the cost of the inverse would be the cost of division.

### Code

```
func preprocess takes an array arr as input:
  Create a new array pre with the same
  length as the original

  pre[0] = arr[0]
  For i in 1 to the length of arr:
    - In this example we are using
    - addition. As discussed in the
    - Requirements section, a prefix
    - sum array works on any operation
    - forming a group, so the addition below
    - can be replaced with, for example, multiplication.
    pre[i] = pre[i-1] + arr[i]

  return pre

func query takes two integers start and end as input:
  - We assume that start and end are zero-indexed.
  - We also assume that we want to query inclusive.
  - Since we used addition in preprocessing, we will
  - use the inverse of addition here, subtraction.
  if start == 0:
    return pre[end]
  else:
    return pre[end] - pre[start-1]

func update takes two integers newval and index as input:
  - We assume that we are replacing values
  - already in the array, rather than inserting
  - any.
  arr[index] = newval

  if index == 0:
    pre[0] = arr[i]
    For i in 1 to the length of arr:
      - Again, the statements about changing this
      - if you use a different operator than addition
      - hold.
      pre[i] = pre[i-1] + arr[i]
  else:
    For i in index to the length of arr:
      pre[i] = pre[i-1] + arr[i]
```

### Requirements

A prefix sum array is only guaranteed to work on a group. \(See the section on Group theory.\) For example, prefix sum arrays do not work with operations such as $$min$$. In part this is because the operation needs a \(unique\) inverse. For example, the min function does not work with prefix sum tables.

### Tips

A prefix sum array is not well suited to cases where updates are required due to its $$O(N)$$ update time complexity; in these cases it is overwhelmingly likely that a range tree will be a better choice.

## Sparse Tables

### Summary

A sparse table is represented as a 2D array of size $$log N$$ by $$N$$. `Table[i][j]` represents the result of the 'product' of the elements $$j$$ through $$2^i+j$$. \(Non-inclusive in this case.\) The solution is then found by finding the 'product' of the 2-power 'bucket' starting at the left edge of the query range and that ending at the right. Since these may overlap Sparse Tables only work for idempotent operators such as $$min$$, $$max$$ and $$lcm$$.

We can also represent a sparse table as a 1D array, meaning we only use $$N$$ space, rather than $$N log N$$. This can be done by representing each row of the original table as a consecutive segment of the 1D array. The example given here is $$N log N$$, which is good enough for any practical example: N up to $$67\,108\,864$$ works within $$64$$ MiB and up to $$268\,435\,436$$ within $$256$$ MiB, which tends to be the upper bound in programming contests.

A sparse table allows us to do queries in $$O(1)$$ time, although updates are $$O(N)$$ - if there are any updates a range tree is a better option.

### Complexity

| Preprocessing | Query | Update | Space |
| :---: | :---: | :---: | :---: |
| $$O(N)$$ | $$O(1)$$ | $$O(N)$$ | $$O(N log N)$$ |

### Pseudocode

```
array table of size [log MAX_N][MAX_N]

func preprocess takes array arr as input:
  - We are using min as an example here.
  - Keep in mind operators need to be idempotent
  - so operations such as addition do not work.
  For i in 0 to length of arr:
    table[0][i] = arr[i]

  for p in 0 to the floor of log2(length of arr):
    for i in 0 to length of arr:
      table[p+1][i] = min(table[p][i],
                          table[p][i+(1<<p)])

func query takes two integers l, r as input:
  - l and r represent the query range.
  if l == r:
    return table[0][l]

  p = floor of log2(r-l + 1)

  return min(table[p][l], table[p][b-(1<<p)+1])

func update takes pos, new, array arr as input:
  - You can actually implement an update
  - for sparse tables, but the $O(N)$ speed means
  - you might as well just preprocess.
  arr[pos] = new
  preprocess(arr)
```

### Requirements

A sparse table only works on a set $$S$$ and operator $$*$$ if $$*$$ is associative, commutative and idempotent. Examples include the $min$ function. \(No inverse is required.\)

### Tips

Don't bother using the inclusion-exclusion principle on sparse tables as you could equally well have used a prefix sum array.

## Priority Queue

A data structure which allows adding elements and popping the smallest / largest / some other as defined by a comparator function. If implemented as a binary heap, a common implementation, has `O(log N)` update and pop.

You can provide comparator functions as per the entry on [http://cppreference.com](http://cppreference.com).

```
#include <queue>

...

priority_queue<int> q;
q.push(4);
q.push(8);
q.push(6);

cout << q.top() << endl; // 8
q.pop();
```

## Binary Heap

One implementation of a priority queue. In particular a binary heap consists of a root node with two children, who may have children and so on; the children satisfy the heap invariant, which states that each of the children have a higher value than their parent; in the way it is implemented in the C++ STL, this becomes each of the children having a lower value than their parent. Binary heaps have `O(log N)` update and pop.

This is already implemented in the C++ STL. Details on asymptotic time complexity can be found at [http://cppreference.com](http://cppreference.com). Please note the implemented heap is a max heap. It is often adviseable to use a priority queue: `#include <queue> ... priority_queue<int> q;` as custom comparator functions are easier to work with, along with the API being easier in general.

```
#include <algorithm>

...

vector<int> vec;

make_heap(vec.begin(), vec.end());

for ( auto i : {1,5,2,6,3,4} ) {
  vec.push(i);
  push_heap(vec.begin(), vec.end());
}

cout << vec.front() << endl; // 6
pop_heap(vec.begin(), vec.end());
```

## Disjoint set

### Summary

An efficient data structure for storing the connected components of a graph.

### Complexity

| Find | Union | Space |
| :---: | :---: | :---: |
| $$O(1)$$ | $$O(1)$$ | $$O(N)$$ |

\(Assuming both path compression and union by rank are implemented.\)  
Technically the functions Find and Union are inverse Ackermann complexity; however, for all practical values, this is less than 5.

### Pseudocode

```
int parent[MAX_N+1]
int rank[MAX_N+1]
int N

function create takes number of nodes n as input:
  N = n
  for i in range 0 to n inclusive:
    rank[i] = 0
    parent[i] = i

function find takes integer x as input:
  - this is path compression
  if x != parent[x]:
    parent[x] = find(parent[x])

  return parent[x]

- union by rank
function union takes two integers x and y as input:
  x = find(x)
  y = find(y)

  if rank[x] > rank[y]:
    parent[y] = x
  else:
    parent[x] = y

  if rank[x] == rank[y]:
    rank[y]++
```

This implements union by rank and path compression.

