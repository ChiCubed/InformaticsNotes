## format specifier
A specifier for `printf` or `scanf` to indicate that, when the function is executed, it should be replaced with an argument. For example:
```
printf("%d\n",0);
```
Here the `%d` acts as a format specifier. A full list of format specifiers is available at [http://en.cppreference.com/w/cpp/io/c/fprintf](http://en.cppreference.com/w/cpp/io/c/fprintf). Note that many of the format specifiers are the same between `printf` and `scanf`. (Ensure that you do not get caught out by the