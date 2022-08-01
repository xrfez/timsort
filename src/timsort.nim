#
#
## TimSort is a sorting algorithm based on Insertion Sort and Merge Sort.
## Used in Java’s Arrays.sort() as well as Python’s sorted() and sort().
## First sort small pieces using Insertion Sort, then merges the pieces using
## a merge of merge sort.
##
##


const RUN: int = 32

proc insertionSort[T](myRun: var openArray[T], left: int, right: int) =
  for i in left + 1..right:
    let temp = myRun[i]
    var j = i - 1
    while j >= left and myRun[j] > temp:
      myRun[j+1] = myRun[j]
      dec j
    myRun[j+1] = temp

proc insertionSortIndex[T](myRun: var openArray[T], left: int, right: int,
    idx: var seq[int]) =
  for i in left + 1..right:
    let temp1 = myRun[i]
    let temp2 = idx[i]
    var j = i - 1
    while j >= left and myRun[j] > temp1:
      myRun[j+1] = myRun[j]
      idx[j+1] = idx[j]
      dec j
    myRun[j+1] = temp1
    idx[j+1] = temp2

proc merge[T](myRun: var openArray[T], l, m, r: int) =
  let
    len1 = m - l + 1
    len2 = r - m
  var
    left: seq[T]
    right: seq[T]
  for i in 0..<len1:
    left.add myRun[l + i]
  for i in 0..<len2:
    right.add myRun[m + 1 + i]

  var
    i = 0
    j = 0
    k = l

  while i < len1 and j < len2:
    if left[i] <= right[j]:
      myRun[k] = left[i]
      inc i
    else:
      myRun[k] = right[j]
      inc j
    inc k

  while i < len1:
    myRun[k] = left[i]
    inc k
    inc i

  while j < len2:
    myRun[k] = right[j]
    inc k
    inc j

proc mergeIndex[T](myRun: var openArray[T], l, m, r: int, idx: var seq[int]) =
  let
    len1 = m - l + 1
    len2 = r - m
  var
    left: seq[T]
    right: seq[T]
    leftIdx: seq[int]
    rightIdx: seq[int]
  for i in 0..<len1:
    left.add myRun[l + i]
    leftIdx.add idx[l + i]
  for i in 0..<len2:
    right.add myRun[m + 1 + i]
    rightIdx.add idx[m + 1 + i]

  var
    i = 0
    j = 0
    k = l

  while i < len1 and j < len2:
    if left[i] <= right[j]:
      myRun[k] = left[i]
      idx[k] = leftIdx[i]
      inc i
    else:
      myRun[k] = right[j]
      idx[k] = rightIdx[j]
      inc j
    inc k

  while i < len1:
    myRun[k] = left[i]
    idx[k] = leftIdx[i]
    inc k
    inc i

  while j < len2:
    myRun[k] = right[j]
    idx[k] = rightIdx[j]
    inc k
    inc j

proc timSort*[T](arr: var openArray[T]) =
  ## Stable Sort, in-place based on the default python algorithm.
  ## Accepts sequence and array containers
  runnableExamples:
    var arr1 = @["bannana", "Apple", "cat"]
    arr1.timSort
    assert arr1 == ["Apple", "bannana", "cat"]
    var arr2 = @[-2, 7, 15, -14, 0, 15, 0, 7, -7, -4, -13, 5, 8, -14, 12]
    arr2.timSort
    assert arr2 == [-14, -14, -13, -7, -4, -2, 0, 0, 5, 7, 7, 8, 12, 15, 15]

  let n = arr.len
  for i in countup(0, n - 1, RUN):
    insertionSort(arr, i, min(i + RUN - 1, n-1))

  var size: int = RUN
  while size < n:
    for left in countup(0, n-1, 2*size):
      let
        mid = left + size - 1
        right = min(left + 2 * size - 1, n - 1)
      if mid < right:
        merge(arr, left, mid, right)
    size *= 2

proc timSort*[T](arr: var seq[seq[T]],
    sortIndex: varargs[int] = 0) =
  ## Stable Sort, based on timSort.
  ## Accepts sequence containers
  ## Sorts based on column criteria
  runnableExamples:
    var arr3 = @[@[2, 2, 2, 2, 1, 1, 1, 1, 3, 3, 3, 3], @[4, 3, 2, 1, 2, 3, 4,
        1, 5, 6, 7, 8], @[8, 7, 6, 5, 4, 3, 2, 1, 9, 10, 11, 12]]
    timSort(arr3, @[0, 1])
    check arr3 == @[@[1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3], @[1, 2, 3, 4, 1, 2,
        3, 4, 5, 6, 7, 8], @[1, 4, 3, 2, 5, 6, 7, 8, 9, 10, 11, 12]]
    var arr4 = @[@[2, 2, 2, 2, 1, 1, 1, 1, 3, 3, 3, 3], @[4, 3, 2, 1, 2, 3, 4,
        1, 5, 6, 7, 8], @[8, 7, 6, 5, 4, 3, 2, 1, 9, 10, 11, 12]]
    arr4.timSort(0, 1)
    check arr4 == @[@[1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3], @[1, 2, 3, 4, 1, 2,
        3, 4, 5, 6, 7, 8], @[1, 4, 3, 2, 5, 6, 7, 8, 9, 10, 11, 12]]

  var input = arr
  var idx: seq[int]
  for i in 0..<arr[0].len:
    idx.add i
  let n = arr[0].len

  for col in countdown(sortIndex.len - 1, 0, 1):
    for i in countup(0, n - 1, RUN):
      insertionSortIndex(arr[sortIndex[col]], i, min(i + RUN - 1, n-1), idx)

    var size: int = RUN
    while size < n:
      for left in countup(0, n-1, 2*size):
        let
          mid = left + size - 1
          right = min(left + 2 * size - 1, n - 1)
        if mid < right:
          mergeIndex(arr[sortIndex[col]], left, mid, right, idx)
      size *= 2

    #use idx[] to rebuild data
    for index, row in idx:
      for column in 0..<arr.len:
        if col != column:
          arr[column][index] = input[column][row]
