# timsort

`nimble install timsort`

This library has no dependencies other than the Nim standard library

## About

TimSort is a sorting algorithm based on Insertion Sort and Merge Sort.
Used in Java’s Arrays.sort() as well as Python’s sorted() and sort().
First sort small pieces using Insertion Sort, then merges the pieces using
a merge of merge sort. Support for sorting 2D containers with multiple criteria.
Benchmarks show a 15-20% improvement over std/algorithm.sort on suedo random data.


```nim
var arr = @[6, 5, 4, 3, 2, 1].timSort
assert arr == @[1, 2, 3, 4, 5, 6]

var arr = @["bacon", "ham", "eggs"].timSort
assert arr == @["bacon", "eggs", "ham"]

var arr = @[@[4, 4, 2, 1], @[4, 3, 1, 2], @[1, 2, 3, 4]].timsort(0, 1)
assert arr = @[@[1, 2, 4, 4], @[2, 1, 3, 4], @[4, 3, 2, 1]]
```

It will sort 2D sequences and accepts criteria as `varargs`
