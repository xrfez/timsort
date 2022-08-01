# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import timsort
#test "can add":
#  check add(5, 5) == 10

test "Runnable Examples":
  var arr1 = @["bannana", "Apple", "cat"]
  arr1.timSort
  check arr1 == ["Apple", "bannana", "cat"]
  var arr2 = @[-2, 7, 15, -14, 0, 15, 0, 7, -7, -4, -13, 5, 8, -14, 12]
  arr2.timSort
  check arr2 == [-14, -14, -13, -7, -4, -2, 0, 0, 5, 7, 7, 8, 12, 15, 15]

test "Index":
  var arr3 = @[@[2, 2, 2, 2, 1, 1, 1, 1, 3, 3, 3, 3], @[4, 3, 2, 1, 2, 3, 4, 1,
      5, 6, 7, 8], @[8, 7, 6, 5, 4, 3, 2, 1, 9, 10, 11, 12]]
  timSort(arr3, @[0, 1])
  check arr3 == @[@[1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3], @[1, 2, 3, 4, 1, 2, 3,
      4, 5, 6, 7, 8], @[1, 4, 3, 2, 5, 6, 7, 8, 9, 10, 11, 12]]
  var arr4 = @[@[2, 2, 2, 2, 1, 1, 1, 1, 3, 3, 3, 3], @[4, 3, 2, 1, 2, 3, 4, 1,
      5, 6, 7, 8], @[8, 7, 6, 5, 4, 3, 2, 1, 9, 10, 11, 12]]
  arr4.timSort(0, 1)
  check arr4 == @[@[1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3], @[1, 2, 3, 4, 1, 2, 3,
      4, 5, 6, 7, 8], @[1, 4, 3, 2, 5, 6, 7, 8, 9, 10, 11, 12]]
