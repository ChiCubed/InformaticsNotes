# C++ notes
## "The bits trick"
The `bits/stdc++.h` header is a testing header which imports every standard c++ (and c) header, which makes it very useful for programming competitions. You can import `<bits/stdc++.h>` on Linux systems, and with some workarounds on macOS. The issue on some operating systems is that `stdc++.h` is included in GNU G++, which is not what is installed on macOS in particular; by default macOS uses Clang. One way around this is simply to install GNU G++ on your system. It may already be installed - if there is a `g++` command which ends in a `-*`, where `*` represents a version number (e.g. `g++-6`) then this is very likely GNU G++.

One other workaround is as follows.

1. Create a file named `stdc++.h` in a folder named `bits` in the folder that you will be doing all of your programming in (alternatively, you can put it somewhere else and use an absolute pathname in step 3)
2. Fill the file with the contents of the following file: https://gist.github.com/eduarc/6022859 (Please note that this is the header for `gcc 4.8.0`, so is likely outdated. Also, ensure you do this *before* the exam has begun.) This may not be up in future; if not, you will have to do some digging for the `bits/stdc++.h` source code. I recommend searching something like `bits/stdc++.h source file`.
3. In a terminal, use the `export` command to change the value of the `CPLUSPLUS_INCLUDE_DIR` variable to either `.` or the absolute path of the `bits` folder's superfolder. On bash and bourne shells, this is similar to the following:  
`export CPLUSPLUS_INCLUDE_DIR='.'`  
You may want to put this in your `~/.bash_profile` or `~/.profile` files if you are planning on having more than one terminal open. (In particular on macOS `~/.bash_profile` is adviseable as if it exists as *well* as a `~/.profile` file the only one that will be read is `~/.bash_profile`.)  
**Alternatively**, In your code, use `"bits/stdc++.h"` instead of `<bits/stdc++.h>` everywhere (note the double quotes instead of angle brackets.)

Now write a test program which prints `Hello World!` using the `bits/stdc++.h` header. If there are any compilation errors, delete the offending headers in the `stdc++.h` source file.

## `using namespace std`
It is *always* adviseablle in Informatics competitions to add a `using namespace std` line to the top of your code. This allows you to shorten the length of the names of all of the standard library containers you import, for example: `std::cout` becomes just `cout`. Keep in mind that this is barely ever a good idea outside of informatics competitions.

## `cppreference`
The online resource http://cppreference.com/ is very useful for informatics competitions. In particular, it gives you information about the runtime complexities of all the STL data structures. (It also tells you the headers which the classes are located in if you're not using the `bits` trick.) Most competitions will allow you to use any online C++ documentation, in which case `cppreference` is highly recommended.

## Vectors vs. Arrays
The `vector` class (defined in header `<vector>`) is similar to an array, but dynamically resizes, so one can 'push back' and 'pop' from a vector. Unlike an array, one does not need to specify the size of a `vector` beforehand (although you can if you want - see the `resize` and `reserve` functions.)

Vectors are slower than arrays but only slightly. It may be adviseable to use vectors instead of arrays in the general case.

## Set and Unordered Set
The `set` class (`<set>`) is a collection of elements that maintains sorted order, i.e. any new element inserted into the set is automatically placed in the set such that the set is sorted, and popping off the set always returns the lowest element. In this regard it is similar to a `priority_queue`, but you can access elements in the middle of the set (and a set is slower.)

The `unordered_set` class (`<unordered_set>`) is a collecion of elements where order is not maintained, and popping could return any element from the set. (Technically popping actually involves checking the element at `set.begin()`; erasing is a different method.) This is *always* better than `set` if the order of elements is not important, i.e. you are storing which of a group of people are currently in a room. One alternative is, if the identifiers of the people (or whatever it may be) are integers or can be transformed into integers, to create an array of booleans, corresponding to whether element `i` is in the set. (Also look into the `bitset` class.)

## Range based for loops, auto specifier
C++11 introduces both range-based for loops and the `auto` specifier. To compile your code using C++11, insert the flag `std=c++11` into your compilation command.

The `auto` specifier works as follows:
```
auto x = 1;
```
This creates a new variable `x` whose type is inferred to be `int`.

Range-based for loops work as follows:
```
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

## Out of memory?
Firstly, check that you actually shouldn't be out of memory.

Also note that huge arrays in `main` or another function will probably crash your program, as it is being initialised on the *stack* (where currently run functions are stored in the memory.)

```
int main(int argc, char* argv[]) {
  int huge[134217728]; // 128 MiB - probably cause a crash
  
  return 0;
}
```

Such arrays should be placed in global scope, outside of any functions, so they are allocated on the *heap* (which is much larger than the stack, although slower):

```
int huge[134217728];

int main(int argc, char* argv[]) {
  return 0;
}
```

## Array initialisation
You can initialise an n-dimensional array to all 0s as follows: (this only works at initialisation)
```
int graph[1000][1000][2] = {0};
```

(If a variable is initialised outside of a function i.e. in global scope, on the heap, it will be initialised by default to 0. You can of course add in the `= {0}` anyway.)

Note this does not work with other integers such as `1`; doing this will only initialise the first value in the array to the value in braces, and everything else will be given a 'default value' of sorts, which happens to be `0`. This is fine if this is what you want to happen.

```
int graph[1000] = {1};
cout << graph[0] << graph[1] << graph[2] << endl; // 100
```

## `#define` and `typedef`
C++ includes a `#define` preprocessor macro.
```
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

```
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
```
  cout << (50+10*2) << endl;
```
which of course evaulates to 70.

C++ also has a `typedef` keyword.

```
#include <bits/stdc++.h>

using namespace std;

typedef pair<int,int> pi;

int main(int argc, char* argv[]) {
  pi a;
  
  cout << a.first << a.second << endl; // 00
  
  return 0;
}
```

One other method is to use the `using` keyword. This may seem more logical than using `typedef`, as it carries the connotations of variable assignment.

```
...

using pi = pair<int,int>;
...
```

## Do I really have to add arguments to `main`?
No.
(You're probably looking for more of an answer than No. The long version is, in competitive programming, adding those arguments is just a waste of 22 keystrokes' worth of your time. I do it here out of habit / for clarity / etc.)

## Printing
You may be used to using `cout` for all your priting. For example:

```
#include <bits/stdc++.h>
using namespace std;
int main(int argc, char* argv[]) {
  
}
```