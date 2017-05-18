

# General notes
- When for loops are used, they are exclusive of the upper bound / follow the C behaviour unless otherwise noted.
- Complexities of algorithms are given in the following format: $O(a,b)$, where a is the time complexity and b the space complexity. (Please see the Mathematics section for an explanation of Big-O notation)
- Complexities refer to the complexity of the solution given here, not necessarily the best possible complexity of any algorithm found to date.
- $log$ is $log_2$ unless otherwise noted.
- In some problems where the order of input is not important, it is a good idea to randomise the input. If your solution is timing out but only slightly on some of the larger test cases, it is a good idea to try randomising the input. The function `random_shuffle` (defined in header `<algorithm>`) can shuffle an input array `arr` as follows: `random_shuffle(arr,arr+arr_length);`.