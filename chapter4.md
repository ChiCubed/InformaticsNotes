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
  // The addition is evaluated first.
  return (a+b>>1);
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
  // Remove arr[l] from this expression if
  // you don't want to update the original
  // array.
  if (l==r) return tree[pos]=arr[l]=val;
  
  // We contain the index to update.
  int m=mid(l,r);
  return tree[pos]=min(update(l,  m,(pos<<1)+1,i,val),
                       update(m+1,r,(pos<<1)+2,i,val));
}
```

### Golfed

To 'golf' code essentially means to make it shorter.

```cpp
#include <bits/stdc++.h>
using namespace std;

const int VERY_BIG_NUMBER = 1000000;
const int MAX_ARRAY_LENGTH = 100000;
const int INF           = 100000000;

int tree[VERY_BIG_NUMBER];
int arr[MAX_ARRAY_LENGTH];

// to get rid of warnings,
// add brackets around (a)+(b)
#define mid(a,b) ((a)+(b)>>1)

int preprocess(int l, int r, int pos) {
  if (l==r)return tree[pos]=arr[l];
  int m=mid(l,r);
  return tree[pos]=min(preprocess(l,m,(pos<<1)+1),
                       preprocess(m+1,r,(pos<<1)+2));
}

int query(int l, int r, int pos, int s, int e) {
  if (s<=l&&r<=e)return tree[pos];
  if (e<l||r<s)return INF;
  int m=mid(l,r);
  return min(query(l,m,(pos<<1)+1,s,e),
             query(m+1,r,(pos<<1)+2,s,e));
}

int update(int l, int r, int pos, int i, int val) {
  if (i<l||r<i)return tree[pos];
  if (l==r)return tree[pos]=arr[l]=val;
  int m=mid(l,r);
  return tree[pos]=min(update(l,m,(pos<<1)+1,i,val),
                       update(m+1,r,(pos<<1)+2,i,val));
}
```

### Requirements

A range tree works on any associative operators.

Identities are not necessary if you implement a range tree differently, that is by returning a placeholder value if a node is out of range in the query function and checking for that placeholder being returned.

**ASIDE**: There _are_ actually associative operators without identities, although of course it is very unlikely these will turn up in an informatics competition.

## Binary Indexed Tree

### Summary

A binary indexed tree (or Fenwick tree) is used to calculate the result of the application of some associative operator (e.g. addition) across a range in an array, similar to a range tree. (It is designed to make the prefix sum easy to calculate, so it may be described as a blend between a range tree and a prefix sum data structure.) It only requires less than half the space of a range tree, however, and is easier/quicker to implement.

A binary indexed tree is typically faster than a range tree.

### Complexity

| Preprocessing | Query | Update | Space |
| :---: | :---: | :---: | :---: |
| $$O(N)$$ | $$O(log N)$$ | $$O(log N)$$ | $$O(N)$$ |

### Code

```cpp
#include <bits/stdc++.h>

using namespace std;

const int MAX_ARRAY_LENGTH = 100000;

// This is, by default, initialised to 0.
// If not in the global scope, ensure that
// this array is manually zeroed.
int tree[MAX_ARRAY_LENGTH+1];

int arr[MAX_ARRAY_LENGTH];


// Get the last set bit of the integer
// x.
inline int lsb(int x) {
  // Because of the operator precedence
  // in C++, the unary negation on x
  // is performed before the bitwise and.
  return x&-x;
}

// We include the function declaration
// here so we can use it in preprocess.
void update(int n, int i, int val);


// Preprocess the array.
// Initially this should be called as follows:
// preprocess(ARRAY_LENGTH);
void preprocess(int n) {
  // Assumes the array tree is already zeroed.
  
  for (int i = 0; i < n; ++i) {
    update(n, i, arr[i]);
  }
}

// Returns the sum of the array
// up to index i.
// For range query, one can simply
// query(r) - query(l-1).
int query(int i) {
  int s = 0;
  
  // Since BIT[0] is a dummy...
  int ind = i+1;
  
  // go through the ancestors
  // of the index in the array
  while (ind>0) {
    s += tree[ind];
    ind -= lsb(ind);
  }
  
  return s;
}

// Increment the element at index i by value val.
// n should be the length of the array.
// If one wishes to update the element, each update
// may be made along with an update in the original
// array, and the difference to the original
// array's value may be passed to this function
// rather than the new value.
void update(int n, int i, int val) {
  // For the same reason as in the query function
  int ind = i+1;
  
  while (ind <= n) {
    tree[ind] += val;
    ind += lsb(ind);
  }
}
```

### Golfed

As you may have noticed, the golfed code is a _lot_ shorter than for a range tree.

```cpp
#include <bits/stdc++.h>

using namespace std;

const int MAX_ARRAY_LENGTH = 100000;

int tree[MAX_ARRAY_LENGTH+1];
int arr[MAX_ARRAY_LENGTH];

#define lsb(x) ((x)&(-x))

void update(int n, int i, int val);

void preprocess(int n) {
  for(int i=0;i<n;++i)update(n,i,arr[i]);
}

int query(int i) {
  int s=0;for(++i;i>0;i-=lsb(i))s+=tree[i];
  return s;
}

void update(int n, int i, int val) {
  for(++i;i<=n;i+=lsb(i))tree[i]+=val;
}
```

### Requirements

Technically, a binary indexed tree works on any associative binary operation e.g. addition. However, the implementation given here is unable to handle the case where the operation does not have an inverse (for example, when one wants to find the minimum of a range.) In particular, it cannot find the minimum in an arbitrary range without using some roundabout tricks.

Generally a range tree is better for querying the minimum in a range, and a binary indexed tree is better for almost anything else.

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

```cpp
#include <bits/stdc++.h>

using namespace std;

const int MAX_ARRAY_LENGTH = 100000;

int arr[MAX_ARRAY_LENGTH];
int pre[MAX_ARRAY_LENGTH];

// n is the array size
void preprocess(int n) {
  pre[0] = arr[0];
  
  for (int i=0; i<n; ++i) {
    // In this example we are using addition.
    // We can use any operation with an inverse.
    pre[i] = pre[i-1] + arr[i];
  }
}

int query(int l, int r) {
  // Query range [l,r]
  // We must use the inverse of addition
  // here, which is subtraction.
  // if l=0, we want to query from the start,
  // so we don't subtract anything.
  return pre[r] - (l?pre[l-1]:0);
}

void update(int n, int i, int val) {
  // i is the index, val is the new value
  
  // We can technically optimise this but
  // if there are going to be updates
  // prefix sum is the wrong data structure.
  
  arr[i]=val;
  preprocess(n);
}
```

### Golfed

```cpp
#include <bits/stdc++.h>

using namespace std;

const int MAX_ARRAY_LENGTH = 100000;

int arr[MAX_ARRAY_LENGTH];
int pre[MAX_ARRAY_LENGTH];

void preprocess(int n) {
  pre[0]=arr[0];
  for (int i=0;i<n;++i)pre[i]=pre[i-1]+arr[i];
}

int query(int l, int r) {
  return pre[r]-(l?pre[l-1]:0);
}

void update(int n, int i, int val) {
  arr[i]=val;preprocess(n);
}
```

### Requirements

A prefix sum array is only guaranteed to work on a group. \(See the section on Group theory.\) For example, prefix sum arrays do not work with operations such as $$min$$. In part this is because the operation needs a \(unique\) inverse. For example, the min function does not work with prefix sum tables.

### Tips

A prefix sum array is not well suited to cases where updates are required due to its $$O(N)$$ update time complexity; in these cases it is overwhelmingly likely that a range tree will be a better choice.

## Sparse Tables

### Summary

A sparse table is represented as a 2D array of size $$log N$$ by $$N$$. `Table[i][j]` represents the result of the 'product' of the elements $$j$$ through $$2^i+j$$. \(Non-inclusive in this case.\) The solution is then found by finding the 'product' of the 2-power 'bucket' starting at the left edge of the query range and that ending at the right. Since these may overlap Sparse Tables only work for idempotent operators such as $$min$$, $$max$$ and $$lcm$$.

A sparse table allows us to do queries in $$O(1)$$ time, although updates are $$O(N)$$ - if there are any updates a range tree is a better option.

### Complexity

| Preprocessing | Query | Update | Space |
| :---: | :---: | :---: | :---: |
| $$O(N)$$ | $$O(1)$$ | $$O(N)$$ | $$O(N log N)$$ |

### Code

```cpp
#include <bits/stdc++.h>

using namespace std;

const int MAX_ARRAY_LENGTH = 100000;
// technically this is 17.
// it's always good to overestimate
// slightly to reduce the risk of
// being out of bounds
const int LOG2_MAX_ARR_LEN = 18;

// Preprocessed logarithm array, because
// practically logarithms aren't constant time
int logs[MAX_ARRAY_LENGTH];

int sparse[LOG2_MAX_ARR_LEN][MAX_ARRAY_LENGTH];

int arr[MAX_ARRAY_LENGTH];

// n is the array size
void preprocess(int n) {
  for (int i=0; i<n; ++i) {
    sparse[0][i] = arr[i];
  }
  
  for (int l=0; l<LOG2_MAX_ARR_LEN; ++l) {
    if (l) {
      // note the    <= rather than <
      for (int i=0; i<=n-(1<<l); ++i) {
        // process the next 'level'
        // We're using min in this example;
        // we could have used any other
        // associative + commutative + idempotent
        // operator
        sparse[l][i] = min(sparse[l-1][i],
                           sparse[l-1][i + (1<<(l-1))]);
      }
    }
    
    // Preprocess logarithms
    for (int j=(1<<l); j<(1<<(l+1)) && j<array_size; ++j) {
      logs[j]=l;
    }
  }
}

int query(int l, int r) {
  // returns the result of query
  // over range [l,r]
  int level = logs[r-l + 1];
  return min(sparse[level][l],
             sparse[level][r-(1<<level) + 1]);
}

void update(int i, int val, int n) {
  // Might as well recalculate everything.
  // We can optimise this slightly but sparse
  // tables aren't designed to be recalculated.
  // Also, in this example, this would recalculate
  // all the logarithms. There's no practical
  // use case for updating a sparse table anyway,
  // this function only exists for completeness.
  arr[i] = val;
  preprocess(n);
}
```

### Golfed

```cpp
#include <bits/stdc++.h>

using namespace std;

const int MAX_ARRAY_LENGTH = 100000;
const int LOG2_MAX_ARR_LEN = 18;

int logs[MAX_ARRAY_LENGTH];
int sparse[LOG2_MAX_ARR_LEN][MAX_ARRAY_LENGTH];
int arr[MAX_ARRAY_LENGTH];

void preprocess(int n) {
  for(int i=0;i<n;++i)sparse[0][i] = arr[i];
  for(int l=0;l<LOG2_MAX_ARR_LEN;++l) {
    if(l)
      for(int i=0;i<=n-(1<<l);++i)
        sparse[l][i]=min(sparse[l-1][i],
                sparse[l-1][i+(1<<l-1)]);
    for(int j=(1<<l);j<(1<<l+1)&&j<n;++j)logs[j]=l;
  }
}

int query(int l, int r) {
  int level=logs[r-l+1];
  return min(sparse[level][l],
             sparse[level][r-(1<<level)+1]);
}

void update(int i, int val, int n) {
  arr[i]=val;preprocess(n);
}
```

### Requirements

A sparse table only works on a set $$S$$ and operator $$*$$ if $$*$$ is associative, commutative and idempotent (see the section on [Set Theory](/chapter3/settheory.md#properties-of-binary-operators) for explanation). Examples include the $$min$$ function. No inverse is required.

### Tips

Logarithms aren't practically constant time; precalculating them should increase speed quite significantly. This is implemented in the code sample above.

## Self-Balancing Binary Search Tree

A Self-Balancing Binary Search Tree (SBBST) is a binary tree which can be used for search operations, and often ensures $$O(log N)$$ complexity. A search may be performed by performing a simple binary search over the nodes.

There are two significant implementations of SBBSTs, AVL trees and Red-Black trees. Generally an AVL tree is preferable when there are more queries than updates, and vice versa for a Red-Black tree.

Treaps will also be discussed. Treaps use randomisation to allow expected time complexity to remain $$O(log N)$$.

### AVL Tree

#### Summary

An AVL tree is a binary tree where, for each node, the difference between the height of the left subtree and the height of the right subtree is at most one. (In addition, it is a binary search tree, which means that every node has a value greater than or equal to the maximum of all the values in the left subtree, and less than or equal to the minimum of all the values in the right subtree.)

The code makes reference to the notions of 'rotation' of a subtree. This involves 'moving the root', as indicated in the below ASCII art diagram (sourced from GeeksforGeeks):

```
   z                            z                            x
  / \                          / \                          /  \ 
T1   y   Right Rotate (y)    T1   x      Left Rotate(z)   z      y
    / \  - - - - - - - - ->     /  \   - - - - - - - ->  / \    / \
   x   T4                      T2   y                  T1  T2  T3  T4
  / \                              /  \
T2   T3                           T3   T4
```

It is evident from the above diagram how rotation works. The node in brackets is the root node of the subtree which is being rotated.

The 'balance factor' of a node indicates how balanced it is, and is equal to the height of the left subtree minus the height of the right subtree.

#### Complexity

| Query | Update | Space |
| :---: | :---: | :---: |
| $$O(log N)$$ | $$O(log N)$$ | $$O(N)$$ |

#### Code

(Partially sourced from http://www.geeksforgeeks.org/avl-tree-set-1-insertion/).

I have used the term 'value' since it makes more sense, in my opinion, than 'key'; however, note that the technical term is 'key'.

```cpp
struct AVLNode {
    int value;
    AVLNode *l, *r;
    int height; // height of this subtree
    
    AVLNode(int value) {
        this->value = value;
        l = r = NULL;
        height = 1;
    }
};

// Gets height of node.
// Checks for null.
int height(AVLNode* x) {
    return (x == NULL) ? 0 : x->height;
}

AVLNode* rightRotate(AVLNode* y) {
    AVLNode* x = y->l;
    AVLNode* T = x->r;
    
    // rotate
    x->r = y;
    y->l = T;
    
    // update the heights
    y->height = max(height(y->l), height(y->r)) + 1;
    x->height = max(height(x->l), height(x->r)) + 1;
    
    // return the new root
    return x;
}

AVLNode* leftRotate(AVLNode* x) {
    AVLNode* y = x->r;
    AVLNode* T = y->l;
    
    // rotate
    y->l = x;
    x->r = T;
    
    // update the heights
    x->height = max(height(x->l), height(x->r)) + 1;
    y->height = max(height(y->l), height(y->r)) + 1;
    
    // return the new root
    return y;
}

// Calculate the balance factor
int getBalance(AVLNode* x) {
    return (x == NULL)
           ? 0
           : height(x->l) - height(x->r);
}

// Insert 'value' into the subtree
// with root node.
AVLNode* insert(AVLNode* node, int value) {
    if (node == NULL) return new Node(value);
    
    if (value < node->value)
        node->l = insert(node->l, value);
    else if (value > node->value)
        node->r = insert(node->r, value);
    else
        // This particular BST implementation
        // disallows multiple keys,
        // so we do nothing. The easiest way
        // to handle duplicates is to
        // store a count of how many times
        // the key appears for each node.
        return node;
    
    // Update height
    node->height = max(height(node->l),
                       height(node->r)) + 1;
    
    // Get balance factor
    int balance = getBalance(node);
    
    if (balance > 1 && value > node->l->value)
        node->l = leftRotate(node->l);
    if (balance < -1 && value < node->r->value)
        node->r = rightRotate(node->r);
    
    if (balance > 1 && value != node->l->value)
        return rightRotate(node);
    if (balance < -1 && value != node->r->value)
        return leftRotate(node);
    
    // Remains unchanged.
    return node;
}

// Calculate minimum value in a tree
AVLNode* minValueNode(AVLNode* x) {
    AVLNode* curr = x;
    
    while (curr->l != NULL) curr = curr->l;
    
    return curr;
}

// Delete node of subtree
// with value value and root node.
AVLNode* deleteNode(AVLNode* node, int value) {
    if (node == NULL) return node;
    
    if (value < node->value)
        node->l = deleteNode(node->l, value);
    else if (value > node->value)
        node->r = deleteNode(node->r, value);
    else {
        // This has the same value,
        // so it's the node to be deleted.
        
        // Check if this node only has one child.
        if (node->l == NULL || node->r == NULL) {
            AVLNode* tmp = node->l ? node->l : node->r;
            if (tmp == NULL)
                // This node has no children
                swap(node,tmp);
            else
                // This node has one child
                *node = *tmp;
            free(tmp);
        } else {
            AVLNode* tmp = minValueNode(node->r);
            
            node->value = tmp->value;
            
            node->r = deleteNode(node->r, tmp->value);
        }
    }
    
    // If this subtree only had one node,
    // we're done.
    if (node == NULL) return node;
    
    node->height = max(height(node->l),
                       height(node->r)) + 1;
    
    // check for unbalance
    // and fix it.
    int balance = getBalance(node);
    
    if (balance > 1 && getBalance(node->l) < 0)
        node->l =  leftRotate(node->l);
    
    if (balance < -1 && getBalance(node->r) > 0)
        node->r = rightRotate(node->r);
    
    if (balance > 1) return rightRotate(node);
    if (balance < -1) return leftRotate(node);
    
    return node;
}
```

### Red-Black Tree

#### Summary

(http://www.geeksforgeeks.org/red-black-tree-set-1-introduction-2/)

A red-black tree is an SBBST where:

1. Every node has an assigned colour, red or black
2. The root is always a black node
3. There are no two adjacent red nodes i.e. a red node cannot have a red parent or red child
4. Every path from the root to a leaf node contains the same number of black nodes (including the leaf).

Essentially, maintaining these invariants ensures that the tree has height less than or equal to $$2 log(n+1)$$.

#### Complexity

| Query | Update | Space |
| :---: | :---: | :---: |
| $$O(log N)$$ | $$O(log N)$$ | $$O(N)$$ |

#### Code

See http://www.geeksforgeeks.org/c-program-red-black-tree-insertion/ and http://www.geeksforgeeks.org/red-black-tree-set-3-delete-2/.

```cpp
struct RBNode {
    int value;
    bool isBlack;
    RBNode *l, *r, *parent;
    
    RBNode(int value) {
        this->value = value;
        l = r = parent = NULL;
        isBlack = false;
    }
}* root; // Root is here a global.

RBNode* rotateLeft(RBNode* node) {
    Node* r = node->r;
    
    node->r = r->l;
    if (node->r != NULL) node->r->parent = node;
    
    r->parent = node->parent;
    if (node->parent == NULL) root = r;
    else if (node == node->parent->l)
        node->parent->l = r;
    else node->parent->r = r;
    
    r->l = node;
    node->parent = r;
    
    return node;
}

RBNode* rotateRight(RBNode* node) {
    Node* l = node->l;
    
    node->l = l->r;
    if (node->l != NULL) node->l->parent = node;
    
    l->parent = node->parent;
    if (node->parent == NULL) root = l;
    else if (node == node->parent->l)
        node->parent->l = l;
    else node->parent->r = l;
    
    l->r = node;
    node->parent = l;
    
    return node;
}

RBNode* BSTInsert(RBNode* node, RBNode* add) {
    // First perform the regular BST insert
    if (node == NULL) return add;
    
    if (add->value < node->value) {
        node->l = BSTInsert(node->l, value);
        node->l->parent = node;
    } else if (add->value > node->value) {
        node->r = BSTInsert(node->r, value);
        node->r->parent = node;
    } else {
        // We disallow multiple keys here,
        // but we could store a count
        // with each node.
        // This implementation will work
        // with the assumption that equal
        // nodes go on the left, i.e.
        // the first condition above is
        // changed to <=.
    }
    
    return node;
}

void insert(int value) {
    RBNode* newNode = new Node(value);
    
    root = BSTInsert(root, newNode);
    
    // Now we fix any rule violations caused.
    Node* parent = NULL;
    Node* grand_parent = NULL;
    
    while ((newNode != root) && !newNode->isBlack &&
           !newNode->parent->isBlack) {
        parent = newNode->parent;
        grand_parent = parent->parent;
        
        if (parent == grand_parent->l) {
            Node* uncle = grand_parent->r;
            
            if ((uncle != NULL) && !uncle->isBlack) {
                grand_parent->isBlack = false;
                parent->isBlack = true;
                uncle->isBlack = true;
                newNode = grand_parent;
            } else {
                if (newNode == parent->r) {
                    parent = rotateLeft(parent);
                    newNode = parent;
                    parent = newNode->parent;
                }
                
                grand_parent = rotateRight(grand_parent);
                swap(parent->isBlack, grand_parent->isBlack);
                newNode = parent;
            }
        } else {
            Node* uncle = grand_parent->l;
            
            if ((uncle != NULL) && !uncle->isBlack) {
                grand_parent->isBlack = false;
                parent->isBlack = true;
                uncle->isBlack = true;
                newNode = grand_parent;
            } else {
                if (newNode == parent->l) {
                    parent = rotateRight(parent);
                    newNode = parent;
                    parent = newNode -> parent;
                }
                
                grand_parent = rotateLeft(grand_parent);
                swap(parent->isBlack, grand_parent->isBlack);
                newNode = parent;
            }
        }
    }
    
    root->isBlack = true;
}

RBNode* BSTSearch(RBNode* node, int value) {
    if (!node) return NULL;
    while (node->value != value) {
        if (node->value > value)
            node = node->l;
        else node = node->r;
        if (!node) return NULL;
    }
    return node;
}

RBNode* getSuccessor(RBNode* node) {
    // Gets the successor of the node.
    RBNode* nxt = node->r;
    
    if (nxt != NULL) {
        while (nxt->l != NULL) {
            nxt = nxt->l;
        }
    } else {
        nxt = node->parent;
        while (node == nxt->r) {
            node = nxt;
            nxt = nxt->parent;
        }
        if (nxt == root) return NULL;
    }
    
    return nxt;
}

RBNode* getPredecessor(RBNode* node) {
    RBNode* prv = node->l;
    
    if (prv != NULL) {
        while (prv->r != NULL) {
            prv = prv->r;
        }
    } else {
        prv = node->parent;
        // The reason for the difference
        // with getSuccessor is to allow
        // handling of equal elements.
        while (node == prv->l) {
            if (prv == root) return NULL;
            node = prv;
            prv = prv->parent;
        }
    }
    
    return prv;
}

void fixDelete(RBNode* node) {
    // Restores properties of a red-black
    // tree after the deletion of a node.
    // The argument is the child of the
    // removed node.
    
    RBNode* w;
    
    while (node->isBlack && (root != node)) {
        if (node == node->parent->l) {
            w = node->parent->r;
            if (!w->isBlack) {
                w->isBlack = true;
                node = node->parent;
            } else {
                if (w->r->isBlack) {
                    w->l->isBlack = true;
                    w->isBlack = false;
                    w = rotateRight(w);
                    w = node->parent->r;
                }
                
                w->isBlack = node->parent->isBlack;
                w->parent->isBlack = true;
                w->right->isBlack = true;
                node->parent = rotateLeft(node->parent);
                node = root; // break
            }
        } else {
            w = node->parent->l;
            if (!w->isBlack) {
                w->isBlack = true;
                node->parent->isBlack = false;
                node->parent = rotateRight(node->parent);
                w = node->parent->l;
            }
            if (w->r->isBlack && w->l->isBlack) {
                w->isBlack = false;
                node = node->parent;
            } else {
                if (w->l->isBlack) {
                    w->r->isBlack = true;
                    w->isBlack = false;
                    w = rotateLeft(w);
                    w = node->parent->l;
                }
                w->isBlack = node->parent->isBlack;
                node->parent->isBlack = true;
                w->l->isBlack = true;
                node->parent = rotateRight(node->parent);
                node = root; // break
            }
        }
    }
    node->isBlack = true;
}

void delete(int value) {
    RBNode* toDelete = BSTSearch(root, value);
    
    RBNode* y = ((toDelete->l == NULL) ||
                 (toDelete->r == NULL)) ? toDelete :
                 getSuccessor(toDelete);
    RBNode* x = y->l ? y->l : y->r;
    x->parent = y->parent;
    if (root == x->parent) root->l = x;
    else if (y == y->parent->l) y->parent->l = x;
    else y->parent->r = x;
    
    if (y != toDelete) {
        if (y->isBlack) fixDelete(x);
        
        y->l = toDelete->l;
        y->r = toDelete->r;
        y->parent = toDelete->parent;
        y->isBlack = toDelete->isBlack;
        toDelete->l->parent = y;
        toDelete->r->parent = y;
        if (toDelete == toDelete->parent->l)
            toDelete->parent->l = y;
        else toDelete->parent->r = y;
        delete toDelete;
    } else {
        if (y->isBlack) fixDelete(x);
        delete y;
    }
}
```

### Treap

#### Summary

A treap is essentially a BST where the values (technically keys) of each node is ordered by the BST property (max on left side <= current node <= min on right side), and the 'priorities' of each node is ordered by the max-heap property (max on left side, max on right side <= current node).

Each node is assigned a random priority when they are inserted. The tree is rotated when it is updated to ensure the max-heap property is satisified for the priorities.

#### Complexity

| Query | Update | Space |
| :---: | :---: | :---: |
| $$O(log N)$$ | $$O(log N)$$ | $$O(N)$$ |

#### Code

```cpp
#include <cstdlib> // random

using namespace std;

// It may be advisable
// to srand(some number)
// in the main function.

struct TNode{
    int value;
    int priority;
    TNode *l, *r;
    
    TNode(int value) {
        this->value = value;
        priority = rand();
        l = r = NULL;
    }
} *root; // Global root.

// Query is just a regular binary search.

TNode* insert(TNode* node, int value) {
    if (!node) return new TNode(value);
```

## Priority Queue

A data structure which allows adding elements and popping the smallest / largest / some other as defined by a comparator function. If implemented as a binary heap, a common implementation, has $$O(log N)$$ update and pop.

You can provide comparator functions as per the entry on [http://cppreference.com](http://cppreference.com).

A Priority Queue is defined in the C++ STL; there is no need to create one manually.

(So no, you won't be getting a golfed version.)

```cpp
#include <queue> // or <bits/stdc++.h>

...

priority_queue<int> q;
q.push(4);
q.push(8);
q.push(6);

cout << q.top() << endl; // 8
q.pop();

cout << q.top() << endl; // 6
q.pop();

```

## Binary Heap

One implementation of a priority queue. In particular a binary heap consists of a root node with two children, who may have children and so on; the children satisfy the heap invariant, which states that each of the children have a higher value than their parent; in the way it is implemented in the C++ STL, this becomes each of the children having a lower value than their parent. Binary heaps have $$O(log N)$$ update and pop.

This is already implemented in the C++ STL. Details on asymptotic time complexity can be found at [http://cppreference.com](http://cppreference.com). Please note the implemented heap is a max heap. It is often adviseable to use a priority queue, described above. Normally it is entirely unnecessary to actually use a binary heap; a priority queue can be considered to be a wrapper over it.

```cpp
#include <algorithm> // or <bits/stdc++.h>

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

## Union find

### Summary

(Also known as a Disjoint Set data structure.) An efficient data structure for storing the connected components of a graph. Could also be considered an algorithm.

Has two operations: find and union (hence the name). Each node can be considered to be in a 'group'. 'Find' checks which group a node is in. 'Union' merges two groups, given a node in each of the groups.

### Complexity

| Find | Union | Space |
| :---: | :---: | :---: |
| $$O(1)$$ | $$O(1)$$ | $$O(N)$$ |

(Assuming both path compression and union by rank are implemented.)
Technically the functions Find and Union are inverse Ackermann complexity; however, for all practical values, this is less than 5.

### Code

```cpp
#include <bits/stdc++.h>

using namespace std;

const int MAX_NODES = 100000;

int parent[MAX_NODES+1];
// we can't name it rank because
// my compiler gets angry
int  nrank[MAX_NODES+1];

// n is the number of nodes
void create (int n) {
  // note the    <= instead of <
  for (int i=0; i<=n; ++i) {
    // nrank is already zeroed - don't bother
    parent[i] = i;
  }
}

int find (int x) {
  // This is path compression
  if (x != parent[x]) parent[x] = find(parent[x]);
  return parent[x];
}

// We cannot use the name 'union'
// because it is a specifier in C++
void join (int x, int y) {
  x = find(x); y = find(y);
  
  // This is union by rank
  if (nrank[x] > nrank[y]) parent[y] = x;
  else                     parent[x] = y;
  
  if (nrank[x] == nrank[y]) nrank[y]++;
}
```

This implements union by rank and path compression.

### Golfed

```cpp
#include <bits/stdc++.h>

using namespace std;

const int MAX_NODES = 100000;

int parent[MAX_NODES+1];
int  nrank[MAX_NODES+1];

void create (int n) {
  for(int i=0;i<=n;++i)parent[i]=i;
}

int find (int x) {
  return parent[x]=parent[x]^x?find(parent[x]):x;
}

void join (int x, int y) {
  x=find(x);y=find(y);
  nrank[x]>nrank[y]?parent[y]=x:parent[x]=y;
  nrank[y]+=nrank[x]==nrank[y];
}
```

### Requirements

Nothing really.