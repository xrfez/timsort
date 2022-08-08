import benchy, std/random, std/algorithm, timsort

randomize(123)
var arr1: seq[int]
var arr2: seq[int]

arr1 = @[]
for i in 0..31:
  arr1.add rand(1000)
arr2 = arr1

timeIt "timsort: 32 elemnts seq[int]":
  arr1.timSort
  arr1 = arr2
  keep(arr1)

timeIt "Sort: 32 elemnts seq[int]":
  arr1.sort
  arr1 = arr2
  keep(arr1)

arr1 = @[]
for i in 0..1024:
  arr1.add rand(1000)
arr2 = arr1


timeIt "timsort: 1024 elemnts seq[int]":
  arr1.timSort
  arr1 = arr2
  keep(arr1)

timeIt "Sort: 1024 elemnts seq[int]":
  arr1.sort
  arr1 = arr2
  keep(arr1)

arr1 = @[]
for i in 0..100_000:
  arr1.add rand(1000)
arr2 = arr1

timeIt "timsort: 100_000 elemnts seq[int]":
  arr1.timSort
  arr1 = arr2
  keep(arr1)

timeIt "Sort: 100_000 elemnts seq[int]":
  arr1.sort
  arr1 = arr2
  keep(arr1)

arr1 = @[]
for i in 0..100_000:
  arr1.add rand(1000)
arr2 = arr1

timeIt "Descending timsort: 100_000 elemnts seq[int]":
  arr1.timSort(Descending)
  keep(arr1)
  arr1 = arr2

timeIt "Descending Sort: 100_000 elemnts seq[int]":
  arr1.sort(Descending)
  keep(arr1)
  arr1 = arr2

var arr3: seq[float]
var arr4: seq[float]
for i in 0..100_000:
  arr3.add rand(1000).toFloat
arr4 = arr3

timeIt "timsort: 100_000 elemnts seq[float]":
  arr3.timSort
  keep(arr3)
  arr3 = arr4

timeIt "Sort: 100_000 elemnts seq[float]":
  arr3.sort
  keep(arr3)
  arr3 = arr4

var arr5: seq[string]
var arr6: seq[string]
for i in 0..100_000:
  arr5.add $rand(100000000)
arr6 = arr5

timeIt "timsort: 100_000 elemnts seq[string]":
  arr5.timSort
  keep(arr5)
  arr5 = arr6

timeIt "Sort: 100_000 elemnts seq[string]":
  arr5.sort
  keep(arr5)
  arr5 = arr6
