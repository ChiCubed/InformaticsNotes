# Set / Group theory
_Hold up. What's a set?_
A set is just a group of numbers, like this:
$$
S = \{1, 2, 3\}
$$

Sets never have repeating elements.

A similar structure in C++ would be `unordered_set`. (`set` is similar but is always sorted.)

## Unary / binary operators
A unary operator is an operation that is performed on a single element of a set $$S$$. For example, negation can be a unary operator: $$-x$$.

Binary operators, on the other hand, are performed on pairs of elements. Examples include:

$$
a+b,\;a-b,\;a \times b,\;a/b,\;gcd(a,b),\;a*b
$$

where $$*$$ represents an arbitrary operation.

We say that a set $$S$$ is *closed* under an operation $$*$$ if $$a*b \in S\;\forall a,b \in S$$.

## Properties of binary operators
Some properties that binary operators can have are:

- *Associativity*: $$(a+b)+c = a+(b+c)$$ (by extension this is equal to $$(a+b+c)$$)
- *Commutativity*: $$(a+b) = (b+a)$$
- *Idempotence*: $$a+a = a$$. Note that the 'equals' operator as we use it normally does not have this property; an example is the $$min$$ and $$max$$ functions.
- *Distributivity*: For distributivity we need to define another operator, $$*$$.
We say that $$*$$ distributes over $$+$$ iff $$a+(b*c) = (a*b) + (a*c)$$.

## Existence of an identity
$$e \in S$$ is an identity of $$*$$ iff:
$$
\forall a \in S\;a*e = e*a = a$$.
Examples include $$0$$ for the $$gcd$$ function and $$1$$ for the $$lcm$$ function.

## Semigroups
$$(S,\cdot)$$ is a semigroup if:

- $$S$$ is closed under $$\cdot$$
- $$\cdot$$ is associative

We can use this to perform an optimized query to find $$A_l \cdot A_{l+1} \cdot A_{l+2} \cdot \ldots \cdot A_r$$ in a range $$[L,R]$$ and an array $$A$$.

If $$(S,\cdot)$$ is associative we can bracket it in any way and thus split it up, which is how a range tree works. Therefore range trees work on all associative operators.

## Groups
Suppose every element of $$S$$ has an inverse and $$\cdot$$ has an identity $$e$$.
If $$a \in S$$ has an inverse $$b \in S$$ s.t. $$a \cdot b = e$$ and $$b$$ is unique, $$(S,\cdot)$$ is a group.

With a group, we can use a prefix sum / cumulative sum array to calculate what we wanted to find above; namely $$A_l \cdot A_{l+1} \cdot A_{l+2} \cdot \ldots \cdot A_r$$ in a range $$[L,R]$$ and an array $$A$$. A prefix sum data structure has only an $$O(N)$$ preprocessing time and $$O(inverse)$$ query, where $$inverse$$ is the inverse of $$\cdot$$.