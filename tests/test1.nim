# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import timsort

import random, algorithm

include "sampleData/raw_2D_int.nim"
include "sampleData/Ascending_2D_int_0.nim"
include "sampleData/Ascending_2D_int_12.nim"
include "sampleData/descending_2D_int_03.nim"
include "sampleData/raw_2D_int_len70.nim"
include "sampleData/ascending_2D_int_len70_0.nim"
include "sampleData/ascending_2D_int_len70_01.nim"
include "sampleData/ascending_2D_int_len70_13.nim"
include "sampleData/ascending_2D_int_len70_2.nim"
include "sampleData/raw_2D_string_len70.nim"
include "sampleData/ascending_2D_string_len70_2.nim"


test "Runnable Examples":
  var arr1 = @["bannana", "Apple", "cat"]
  arr1.timSort
  check arr1 == ["Apple", "bannana", "cat"]
  var arr2 = @[-2, 7, 15, -14, 0, 15, 0, 7, -7, -4, -13, 5, 8, -14, 12]
  arr2.timSort
  check arr2 == [-14, -14, -13, -7, -4, -2, 0, 0, 5, 7, 7, 8, 12, 15, 15]

test "Index":
  var included_raw_2D_int_len70 = raw_2D_int_len70
  included_raw_2D_int_len70.timSort
  check included_raw_2D_int_len70 == ascending_2D_int_len70_0

  included_raw_2D_int_len70 = raw_2D_int_len70
  included_raw_2D_int_len70.timSort(0, 1)
  check included_raw_2D_int_len70 == ascending_2D_int_len70_01

  included_raw_2D_int_len70 = raw_2D_int_len70
  included_raw_2D_int_len70.timSort(2)
  check included_raw_2D_int_len70 == ascending_2D_int_len70_2

  included_raw_2D_int_len70 = raw_2D_int_len70
  included_raw_2D_int_len70.timSort(1, 3)
  check included_raw_2D_int_len70 == ascending_2D_int_len70_13

  var arr3 = @[@[2, 2, 2, 2, 1, 1, 1, 1, 3, 3, 3, 3], @[4, 3, 2, 1, 2, 3, 4, 1,
      5, 6, 7, 8], @[8, 7, 6, 5, 4, 3, 2, 1, 9, 10, 11, 12]]
  timSort(arr3, system.cmp[int], Ascending, @[0, 1])
  check arr3 == @[@[1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3], @[1, 2, 3, 4, 1, 2, 3,
      4, 5, 6, 7, 8], @[1, 4, 3, 2, 5, 6, 7, 8, 9, 10, 11, 12]]
  var arr4 = @[@[2, 2, 2, 2, 1, 1, 1, 1, 3, 3, 3, 3], @[4, 3, 2, 1, 2, 3, 4, 1,
      5, 6, 7, 8], @[8, 7, 6, 5, 4, 3, 2, 1, 9, 10, 11, 12]]
  arr4.timSort(system.cmp[int], Ascending, 0, 1)
  check arr4 == @[@[1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3], @[1, 2, 3, 4, 1, 2, 3,
      4, 5, 6, 7, 8], @[1, 4, 3, 2, 5, 6, 7, 8, 9, 10, 11, 12]]

  var tempArr = raw_2D_int
  tempArr.timSort
  check tempArr == ascending_2D_int_0

  tempArr.timSort(1, 2)
  check tempArr == ascending_2D_int_12

  tempArr.timSort(system.cmp[int], Descending, 0, 3)
  check tempArr == descending_2D_int_03

  var tempArr2 = raw_2D_string_len70
  tempArr2.timsort(2)
  check tempArr2 == ascending_2D_string_len70_2


test "Larger Datasets":
  randomize(123)
  var arr1: seq[int]
  for i in 0..31:
    arr1.add rand(1000)
  arr1.timSort
  check arr1.isSorted
  arr1 = @[]
  for i in 0..31:
    arr1.add rand(1000)
  arr1.timSort(Descending)
  check arr1.isSorted(Descending)
  arr1 = @[]
  for i in 0..1024:
    arr1.add rand(1000)
  arr1.timSort
  check arr1.isSorted
  arr1 = @[]
  for i in 0..1024:
    arr1.add rand(1000)
  arr1.timSort(Descending)
  check arr1.isSorted(Descending)
  arr1 = @[]
  for i in 0..100_000:
    arr1.add rand(1000)
  arr1.timSort
  check arr1.isSorted
  arr1 = @[]
  for i in 0..100_000:
    arr1.add rand(1000)
  arr1.timSort(Descending)
  check arr1.isSorted(Descending)
  arr1 = @[]
