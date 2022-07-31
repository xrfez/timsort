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

