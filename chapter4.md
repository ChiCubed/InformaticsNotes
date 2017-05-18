# Data Structures

## Range Tree

### Summary

A range tree allows querying the minimum / sum / product / other operations (see Requirements) of the range $$[L,R]$$ in an array in $$O(log N)$$ time. It is typically the best option for range queries, and its fast updates normally make it the best option for querying a range. There are a few exceptions; for example, when there are no updates and the operation you are using has a unique inverse, prefix tables are a better (and much faster) option; sparse tables can also be used in some cases.

A range tree essentially allows reduction of a query to a lowest common ancestor problem.

### Complexity

| Preprocessing | Query | Update | Space |
| :---: | :---: | :---: | :---: |
| $$O(N)$$ | $$O(log N)$$ | $$O(log N)$$ | $$O(N)$$ |

### Pseudocode

```
array tree of length at least 2*MAX_N-1

func mid takes a, b as input:
   - remember outer brackets - order of ops
  return a + ((b-a)>>1)

func preprocess takes an array arr, l, r, pos as input:
  - We can store the children of the current node
  - as indices 2i+1 and 2i+2.
  - The maximum depth of a range tree is log N.
  - In this example we are using the operation
  - min; range trees work on any associative operators.
  - l and r are the range of the current
  - node in the array;
  - pos is the index in the tree.
  if l == r:
    tree[pos] = arr[l]
    return arr[l]

  middle = mid(l,r)
  - if we were using, say, addition, this would be +
  tree[pos] = min(preprocess(arr, l, middle, 2*pos+1),
                  preprocess(arr, middle+1, r, 2*pos+2))
  return tree[pos]


func query takes pos, l, r, s, e as input:
  - pos represents the current node i.e. where to
  - start searching from; when query is called this
  - should almost always be set to 0.
  - l and r are the edges of the query range.
  - s and e should be 0 and n-1 respectively,
  - or otherwise the range of start.
  if l <= s and r >= e:
    return tree[pos]

  if e < l or s > r:
    return INFINITY - or whatever the identity is;
                    - for addition this would be 0

  middle = mid(s,e)
  - since we are using min in this example
  - if we were using addition we would use +
  return min(query(2*pos + 1, l, r, s, middle),
             query(2*pos + 2, l, r, middle+1, e))


func update takes pos, s, e, new, ind as input:
  - s and e are the bounds of the current node.
  - pos is the same as query.
  - new is the value of the new element.
  - ind is the position of the new element.

  - if the destination index is outside our range
  if ind < s or ind > e:
    return

  if s != e:
    middle = mid(s,e)
    update(2*pos+1, s, middle, new, ind)
    update(2*pos+2, middle+1, new, ind)

    - Another way of doing this is
    - minning each element of the tree
    - with new as we go along;
    - I find this clearer.
    - we use min as, again, it is the operator
    - we have chosen.
    tree[pos] = min(tree[2*pos+1],
                    tree[2*pos+2])
  else:
    arr[ind] = new
    tree[pos] = arr[ind]
```

### Requirements

A range tree works on any associative operators.

Identities are not necessary if you implement a range tree differently, that is by returning a placeholder value if a node is out of range in the query function and checking for that placeholder being returned.

**ASIDE**: There _are_ actually associative operators without identities; for example, strictly upper triangular matrix multiplication, an example from [here](http://math.stackexchange.com/a/1053410/169841). Although of course it is very unlikely these will turn up in an informatics competition.

## Prefix sum

### Summary

A prefix sum array is a data structure which stores the 'sum' of all of the operations up to an index. For example, if you wished to construct a prefix sum array on the array $$[1, 2, 3]$$ using addition as your operation, the prefix sum array would be $$[1, 1+2, 1+2+3]$$.

The name carries connotations of addition but a prefix sum array works on any operation that forms a group with its set $$S$$; see the Requirements section.

### Complexity

| Preprocessing | Query | Update | Space |
| :---: | :---: | :---: | :---: |
| $$O(N)$$ | $$O(inverse)$$\* | $$O(N)$$ | $$O(N)$$ |

\*$$inverse$$ is the cost of performing the inverse of whatever function you have chosen to perform. For example, if you have a prefix sum array using multiplication, the cost of the inverse would be the cost of division.

### Pseudocode

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

