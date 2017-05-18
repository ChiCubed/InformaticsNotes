# Mathematics
## Set / Group theory
_Hold up. What's a set?_
A set is just a group of numbers, like this:
$$
S = \{1, 2, 3\}
$$

Sets never have repeating elements.

A similar structure in C++ would be `unordered_set`.

### Unary / binary operators
A unary operator is an operation that is performed on a single element of a set $$S$$. For example, negation can be a unary operator: $$-x$$.

Binary operators, on the other hand, are performed on pairs of elements. Examples include:

$$
a+b,\;a-b,\;a \times b,\;a/b,\;gcd(a,b),\;a*b
$$

where $$*$$ represents an arbitrary operation.

We say that a set $$S$$ is *closed* under an operation $$*$$ if $$a*b \in S\;\forall a,b \in S$$.

### Properties of binary operators
Some properties that binary operators can have are:

- *Associativity*: $$(a+b)+c = a+(b+c)$$ (by extension this is equal to $$(a+b+c)$$)
- *Commutativity*: $$(a+b) = (b+a)$$
- *Idempotence*: $$a+a = a$$. Note that the 'equals' operator as we use it normally does not have this property; an example is the $$min$$ and $$max$$ functions.
- *Distributivity*: For distributivity we need to define another operator, $$*$$.
We say that $$*$$ distributes over $$+$$ iff $$a+(b*c) = (a*b) + (a*c)$$.

### Existence of an identity
$$e \in S$$ is an identity of $$*$$ iff:
$$
\forall a \in S\;a*e = e*a = a$$.
Examples include $$0$$ for the $$gcd$$ function and $$1$$ for the $$lcm$$ function.

### Semigroups
$$(S,\cdot)$$ is a semigroup if:

- $$S$$ is closed under $$\cdot$$
- $$\cdot$$ is associative

We can use this to perform an optimized query to find $$A_l \cdot A_{l+1} \cdot A_{l+2} \cdot \ldots \cdot A_r$$ in a range $$[L,R]$$ and an array $$A$$.

If $$(S,\cdot)$$ is associative we can bracket it in any way and thus split it up, which is how a range tree works. Therefore range trees work on all associative operators.

### Groups
Suppose every element of $$S$$ has an inverse and $$\cdot$$ has an identity $$e$$.
If $$a \in S$$ has an inverse $$b \in S$$ s.t. $$a \cdot b = e$$ and $$b$$ is unique, $$(S,\cdot)$$ is a group.

With a group, we can use a prefix sum / cumulative sum array to calculate what we wanted to find above; namely $$A_l \cdot A_{l+1} \cdot A_{l+2} \cdot \ldots \cdot A_r$$ in a range $$[L,R]$$ and an array $$A$$. A prefix sum data structure has only an $$O(N)$$ preprocessing time and $$O(inverse)$$ query, where $$inverse$$ is the inverse of $$\cdot$$.

## Amortized complexity \small a.k.a. Big O notation
The amortized complexity of an algorithm can be seen as an average runtime of a function, slightly different from the asymptotic complexity. In particular, amortized complexity should not be greatly impacted by a single case which has an extremely long runtime.

One definition is that, if $$f(x)$$ has an amortized complexity of $$O(1)$$, then over $$N$$ operations the total time divided by $$N$$ is approximately $$1$$.

One example would be an STL vector in C++. It takes constant time to push some number of elements onto the vector, but when the vector's size is doubled to fit more elements the push operation can take up to $$O(N)$$ time. However, the amortized complexity of the push function remains $$O(1)$$, as these doubling slowdowns only occur very rarely.

### Amortized analysis

There are a number of methods for amortized analysis, such as aggregate analysis (essentially finding the upper bound on $$N$$ operations and dividing by N), the accounting method (taking into account the costs, execution time and influence on future operations' run time) and the potential method, also called the physicist's method. The potential method is what will be described here.

The greek capital letter phi ($$\Phi$$) is typically used to represent the cost after $$i$$ operations.

$$\Phi_i$$ is the cost after $$i$$ operations, $$\Phi_0 = 0$$ is the cost after $$0$$ operations, and $$\Phi_i > \Phi_0$$ for all $$i$$. We will also be using $$c_i$$ to represent the cost of the ith operation, $$\hat{c}_i$$ to represent the amortized cost of the ith operation, and $$N$$ to represent the total number of operations.

$$
\hat{c}_i = c_i + \Phi_i - \Phi_{i-1}
$$

$$
\begin{aligned}
\sum_{i=1}^{n}{\hat{c}_i} &= \sum_{i=1}^{n}{c_i} +  ((\Phi_n - \Phi_{n-1}) + (\Phi_{n-1} - \Phi_{n-2}) + \ldots + (\Phi_1 - \Phi_0)) \\
&= \sum_{i=1}^{n}{c_i} + \Phi_n - \Phi_0
\end{aligned}
$$

The amortized time calculated overestimates by $$\Phi_n$$, which means it is always an upper bound on the actual time.

$$\hat{c}_i$$ represents the total runtime; we then divide this by $$N$$ to get the amortized asymptotic complexity.

**Example**  
We have an integer $$x$$. $$x$$ is initially set to $$0$$. $$x$$ is incremented $$N$$ times. The cost of incrementing $$x$$ is the number of bit flips performed, i.e. the cost of incrementing $$2$$ to $$3$$ is $$1$$ and the cost of incrementing $$7$$ to $$8$$ is $$4$$.

Let $$\Phi$$ be the number of ones.
$$\Phi_0 = 0$$

For the $$i$$th operation:
$$
c_i = t_i + 1\\
$$
$$
\begin{aligned}
\Delta{\Phi} &= \Phi_i - \Phi_{i-1}\\
&= 1 - t_i
\end{aligned}
$$

$$
\begin{aligned}
\hat{c}_i &= c_i + \Delta{\Phi}\\
&= t_i + 1 + 1 - t_i\\
&= 2
\end{aligned}
$$

So $$\sum_{i=1}^{n}{\hat{c}_i} = 2n$$.
This is the total runtime and we want to find the average. Therefore, we divide by $$n$$.

$$\frac{2n}{n} = 2 = O(1)$$

So this operation is amortized $$O(1)$$ complexity.

