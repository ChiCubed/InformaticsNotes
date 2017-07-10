# C++ notes

## Vector / array assignment not working

This is a difficult bug to track; I recommend reading this section carefully. (Or skipping to the last line.)

Essentially this may occur when one assigns the value of a vector or array (or another container) to another expression which involves a modification in the original variable.

Here's an oversimplified example with an integer `i`.

```cpp
i = i++;
```

Obviously one would never write code like this. However, this may produce an unexpected result. Testing with GNU g++ 6.1.0, this produced a result equivalent to the following:

```cpp
i = i;
```

In other words, it left the input value unmodified.

The post-increment operator (the `++` after the `i`) is an operator which uses the original value of a variable in an equation, then increments the variable in question. For example, `x = i++` would be equivalent to two commands: `x = i` and `i = i + 1`. In the case given above, `i = i++`, `i` is being assigned to itself, and also being post-incremented. The result on g++ 6.1.0 was that `i` remained unchanged; the user may have desired `i` to be incremented instead.

Here's a more practical example.

```cpp
int u(int a,int b,int c,int i){
  int x=t.size(),y;
  t.push_back(0);
  l.push_back(l[c]);
  r.push_back(r[c]);
  // assert(l.size() == t.size() && t.size() == r.size());
  
  ...

      l[x]=u(a,m,l[c],i); // <--- This is the issue
  ...

  t[x]=t[c]+1;
  return x;
}
```

This is an excerpt from some code for a persistent range tree, slightly modified for clarity. The issue is that l[x] is potentially being modified somehow by the code. `l[x]` is initially equal to `l[c]`, as guaranteed by the assert. So the line commented 'This is the issue' is using `l[x]` in a manner which is not necessarily known to the caller.

This bug fortunately has an easy fix. Simply use an intermediate variable. In the above example, the fix would be:

```cpp
      int tmp=u(a,m,l[c],i);
      l[x]=tmp;
```

The advice here essentially boils down to this:

**TL;DR.** _If an array or vector assignment seems to be 'not working' or producing unexpected results, try adding an intermediate variable._

## "The bits trick"
The `bits/stdc++.h` header is a testing header which imports every standard c++ (and c) header, which makes it very useful for programming competitions. You can import `<bits/stdc++.h>` on Linux systems, and with some workarounds on macOS. The issue on some operating systems is that `stdc++.h` is included in GNU g++, which is not what is installed on macOS in particular; by default macOS uses Clang. One way around this is simply to install GNU g++ on your system. It may already be installed - if there is a `g++` command which ends in a `-*`, where `*` represents a version number (e.g. `g++-6`) then this is very likely GNU g++.

One other workaround is as follows.

1. Create a file named `stdc++.h` in a folder named `bits` in the folder that you will be doing all of your programming in (alternatively, you can put it somewhere else and use an absolute pathname in step 3)
2. Fill the file with the contents of the following file: https://gist.github.com/eduarc/6022859 (Please note that this is the header for `gcc 4.8.0`, so is likely outdated.) This may not be up in future; if not, you will have to do some digging for the `bits/stdc++.h` source code. I recommend searching something like `bits/stdc++.h source file`.
3. In a terminal, use the `export` command to change the value of the `CPLUSPLUS_INCLUDE_DIR` variable to either `.` or the absolute path of the `bits` folder's superfolder. On bash and other Bourne shell derivatives, the following command should work:  
`export CPLUSPLUS_INCLUDE_DIR='.'`  
You may want to put this in your `~/.bash_profile` or `~/.profile` files if you are planning on having more than one terminal open. (In particular on macOS `~/.bash_profile` is adviseable as if it exists as *well* as a `~/.profile` file the only one that will be read is `~/.bash_profile`.)  
**Alternatively**, In your code, use `"bits/stdc++.h"` instead of `<bits/stdc++.h>` everywhere (note the double quotes instead of angle brackets.)

Now write a test program which prints `Hello World!` using the `bits/stdc++.h` header. If there are any compilation errors, delete the offending headers in the `stdc++.h` source file.

## `using namespace std`
It is *always* advisable in Informatics competitions to add a `using namespace std` line to the top of your code. This allows you to shorten the length of the names of all of the standard library containers you import, for example: `std::cout` becomes just `cout`. Keep in mind that this is barely ever a good idea outside of informatics competitions.

## `cppreference`
The online resource [http://cppreference.com/](http://cppreference.com/) is very useful for informatics competitions. In particular, it gives you information about the runtime complexities of all the STL data structures. (It also tells you the headers which the classes are located in if you're not using the `bits` trick.) Many competitions will allow you to use any online C++ documentation, in which case `cppreference` is highly recommended.

## Vectors vs. Arrays
The `vector` class (defined in header `<vector>`) is similar to an array, but dynamically resizes, so one can 'push back' and 'pop' from a vector. Unlike an array, one does not need to specify the size of a `vector` beforehand (although you can if you want - see the `resize` and `reserve` functions.)

Vectors are slower than arrays but only slightly. It may be advisable to use vectors instead of arrays in the general case.

## Set and Unordered Set
The `set` class (`<set>`) is a collection of elements that maintains sorted order, i.e. any new element inserted into the set is automatically placed in the set such that the set is sorted, and popping off the set always returns the lowest element. In this regard it is similar to a `priority_queue`, but you can access elements in the middle of the set (and a set is slower.)

The `unordered_set` class (`<unordered_set>`) is a collecion of elements where order is not maintained, and popping could return any element from the set. (Technically popping actually involves checking the element at `set.begin()`; erasing is a different method.) This is *always* better than `set` if the order of elements is not important, i.e. you are storing which of a group of people are currently in a room. One alternative is, if the identifiers of the people (or whatever it may be) are integers or can be transformed into integers, to create an array of booleans, corresponding to whether element `i` is in the set. (Also look into the `bitset` class.)

## Range based for loops, `auto`
C++11 introduces both range-based for loops and the `auto` specifier. (Along with, I'm sure, many other features.) To compile your code using C++11, insert the flag `-std=c++11` into your compilation command.

The `auto` specifier works as follows:
```cpp
auto x = 1;
```
This creates a new variable `x` whose type is inferred to be `int`.

Range-based for loops work as follows:
```cpp
vector<vector<pair<int,int>>> graph;

... populate graph ...

for (auto n : graph[1]) {
  ... do things ...
}

for (int n : {1,3,5,6}) {
  cout << n << "\n";
}
```

The `auto` specifier is quite often useful in conjuction with a range-based for loop, as in the example above.

Don't overuse the `auto` specifier; it's usually best to be very clear about what type a variable should be.

## Out of memory?
Firstly, check that you actually shouldn't be out of memory.

Also note that huge arrays in `main` or another function will probably crash your program, as they are being initialised on the *stack* (where currently running functions are stored in the memory).

```cpp
int main(int argc, char* argv[]) {
  int huge[134217728]; // 128 MiB - probably cause a crash
  
  return 0;
}
```

Such arrays should be placed in global scope, outside of any functions, so they are allocated on the *heap* (which is much larger than the stack).:

```cpp
int huge[134217728]; // should be fine.

int main(int argc, char* argv[]) {
  return 0;
}
```

## Array initialisation
You can initialise an n-dimensional array to all 0s as follows: (this only works at initialisation)
```cpp
int graph[1000][1000][2] = {0};
```

(If a variable is initialised outside of a function i.e. in global scope, on the heap, it will be initialised by default to 0. You can of course add in the `= {0}` anyway.)

Note this does not work with other integers such as `1`; doing this will only initialise the first value in the array to the value in braces, and everything else will be given a 'default value' of sorts, which happens to be `0`. This is fine if this is what you want to happen.

```cpp
int graph[1000] = {1};
cout << graph[0] << graph[1] << graph[2] << endl; // 100
```

(If you want to initialise everything in the array to some value other than `0`, you'll have to use a for loop.)

## `#define`, `typedef`, `using`
C++ includes a `#define` preprocessor macro.
```cpp
#include <bits/stdc++.h>

using namespace std;

#define INFINITY (2 << 31)
#define max(a,b) ((a)>(b) ? (a) : (b))

int main(int argc, char* argv[]) {
  cout << INFINITY << endl; // 4294967296
  cout << max(5,10) << endl; // 10
  
  return 0;
}
```
This substitutes the strings at runtime. The brackets in the defined function are quite significant. In the below example:

```cpp
#include <bits/stdc++.h>

using namespace std;

#define VARIABLE 50+10
#define ANOTHER (VARIABLE*2)

int main(int argc, char* argv[]) {
  cout << VARIABLE << endl; // 60
  cout << ANOTHER << endl; // 70
  
  return 0;
}
```

We see that because we have left the brackets out around the definition of `VARIABLE` and in the `ANOTHER` function, the arithmetic rules take over. In the above example, line 10 is substituted to:

```cpp
cout << (50+10*2) << endl;
```

which of course evaulates to 70.

While you don't have to use `#define` for the above examples, there are some instances where it is useful to use `#define`. For example, if working with points in a plane:

```cpp
#define x first
#define y second

...

pair<int,int> a;
printf("%d %d",a.x,a.y);
```

You would obviously have to make sure you didn't use a variable named `x` or `y` anywhere else in your program.


If you wish to define a type, you can use the `typedef` keyword. The main use case for `typedef` is to increase typing speed if you're going to be using a type frequently, for example:

```cpp
typedef pair<int,int> pi;
```


One other method is to use the `using` keyword. This may seem more logical than using `typedef`, as the syntax carries the connotations of variable assignment.

```cpp
using pi = pair<int,int>;
```

## Do I have to add arguments to `main`?
No.

## Printing
You may be used to using `cout` for all your priting. For example:

```cpp
#include <bits/stdc++.h>

using namespace std;

int main(int argc, char* argv[]) {
  int x = 1;
  
  cout << "The value of x is " << x << endl;
  
  return 0;
}
```

It may be intuitive, but you will probably find when debugging that this syntax is just too cumbersome to type. It's annoying to have to type a debug statement that prints five or six variables at once using `cout`, due to the fact you have to separate each of the variables with `<<`.

(Also, `cout` and `endl` are _slow_.)

Enter `printf`. `printf` is almost always preferable to using `cout`, due to the speed improvements in terms of both typing and code execution. Initially `printf` will seem slower to type, and there are a number of format specifiers you will have to remember. The equivalent of the `cout` statement in the above code is:
```cpp
printf("The value of x is %d\n",x);
```
We've used a format specifier here, namely `%d`. Note that we've included a carriage return (`\n`).

A full list of format specifiers is available at [http://en.cppreference.com/w/cpp/io/c/fprintf](http://en.cppreference.com/w/cpp/io/c/fprintf). Note that many of the format specifiers are the same between `printf` and `scanf`.

Ensure that you use the correct format specifier, i.e. to print a long long you must use `%lld`. This is one disadvantage of `printf` as opposed to `cout`: with `cout` you don't have to worry about types.

If you're using a `std::string` to represent string types, you'll have to print the underlying C-string when using `printf`, as follows:
```cpp
printf("%s\n",somestr.c_str());
```

## Ternary operator
This is basically a shortcut for an if/else statement, and is useful if you need to calculate a value based on a conditional.

The syntax is as follows:
`condition ? value_if_true : value_if_false`

One example of where this is useful is calculating a factorial (recursively). Normally when calculating a factorial recursively you must put a 'base case' on a different line to the `return` statement:

```cpp
int fact(int n) {
  if (n <= 0) return 1;
  return n*fact(n-1);
}
```

Using the ternary operator, we can shorten this to:

```cpp
int fact(int n) {
  return (n>0?n*fact(n-1):1);
}
```

(The brackets around the ternary expression are unnecessary.)

## Binary and Bit Shifting
**Q**: How do I quickly find $$2^x$$?
**A**: You use bit shifting.

In C++ (as well as most major programming languages) integers are represented as binary numbers.

In binary, also known as Base 2, every place value is a power of 2 rather than a power of 10. To illustrate this, let's calculate the decimal value of a binary number: `0b00101001`. (The `0b` is a convention to indicate that you're using binary.)

The $$1$$ at the end is equal to $$1$$ in decimal. No surprises there.
The $$0$$ to the left is equal to $$0*2^1$$. While this doesn't actually change anything here, in Base 10 the $$0$$ would represent $$0*10^1$$.
The $$1$$ three before the last digit is equal to $$1*2^3$$, or $$8$$. If the number were in Base 10, the $$1$$ would represent $$1*10^3$$, or $$1000$$.

As you can see the number being raised to a power is the Base, and the power it is being raised to is the distance from the end. Therefore a digit $$d$$ that is $$a$$ places from the end is equal to $$d*b^a$$ in base $$b$$.

Great, now I speak binary. What does this have to do with Bit Shifting?

Bit shifting works by literally shifting the bits in the binary representation of a number (the individual digits in a binary number are called bits). You can think of it  as multiplying or dividing by a power of 2.

Bit shifting uses the `<<` and `>>` operators, which you may recognise if you have used `cin` or `cout`.

Two examples of the syntax:
`0b00010110 << 2` &rarr; `0b01011000`
`0b00100111 >> 1` &rarr; `0b00010011`

Note that in the second case the `1` at the end has been truncated.

Translating these examples to decimal:
`22 << 2` &rarr; `88`
`39 >> 1` &rarr; `19`

Important **NOTE**: Bit shifting has a very low 'operator precedence'. That means it will be evaluated after other operations, such as addition. For example:

`10 + 1<<2` &rarr; `11<<2` &rarr; `44`

This may not be what you were expecting: you usually want the left shift to be performed first, and indeed this seems intuitive. The fix is to wrap the `<<` in brackets to make sure that the compiler knows which one you want:

`10 + (1<<2)` &rarr; `10 + 4` &rarr; `14`

How do I use this to find $$2^x$$? You can find `1<<x`, which evaluates to $$2^x$$.

(By the way, bit shifting is usually faster than multiplication or division. So if you're timing out by a couple nanoseconds, go ahead and replace all instances of `x*2` with `(x<<1)`.)



## `sort` and `random_shuffle`

Sometimes you will be given all of the input before your program begins executing. It is occasionally a good idea to sort this input, as this may make it faster to process later. The function `std::sort` (defined in header `<algorithm>`) sorts an input array `arr` as follows: `std::sort(arr, arr+arr_length);`.

In other problems where the order of input is not important, it is a good idea to randomise the input. If your solution is timing out but only slightly on some larger test cases, it is a good idea to try randomising the input. The function `std::random_shuffle` (defined in header `<algorithm>`) can shuffle an input array `arr` as follows: `std::random_shuffle(arr, arr+arr_length);`.