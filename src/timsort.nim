#
#
## TimSort is a sorting algorithm based on Insertion Sort and Merge Sort.
## Used in Java’s Arrays.sort() as well as Python’s sorted() and sort().
## First sort small pieces using Insertion Sort, then merges the pieces using
## a merge of merge sort.
##
##

import std/algorithm
export SortOrder

const RUN: int = 32

const onlySafeCode = true

template `<-`(a, b) =
  when defined(gcDestructors):
    a = move b
  elif onlySafeCode:
    shallowCopy(a, b)
  else:
    copyMem(addr(a), addr(b), sizeof(T))

proc insertionSort[T](myRun: var openArray[T], left: int, right: int,
    cmp: proc (x, y: T): int {.closure.}, order: SortOrder) =

  var
    j: int
    temp: T

  template comparison(body: untyped) =
    for i in left + 1..right:
      temp = myRun[i]
      j = i - 1
      while j >= left and body:
        swap(myRun[j+1], myRun[j])
        dec j

  if cmp == system.cmp[T]:
    # Dont use system.cmp because it is slower
    case order:
      of Ascending: comparison myRun[j] > temp
      of Descending: comparison myRun[j] < temp
  else:
    # use custom cmp()
    case order:
      of Ascending: comparison cmp(myRun[j], temp) == 1
      of Descending: comparison cmp(myRun[j], temp) == -1

proc insertionSortIndex[T](myRun: var openArray[T], left: int, right: int,
    cmp: proc (x, y: T): int {.closure.}, order: SortOrder,
    idx: var seq[int]) =

  var
    j: int
    temp: T
    #temp2: int

  template comparison(body: untyped) =
    for i in left + 1..right:
      temp = myRun[i]
      #temp2 = idx[i]
      j = i - 1
      while j >= left and body:
        swap(myRun[j+1], myRun[j])
        swap(idx[j+1], idx[j])
        dec j

  if cmp == system.cmp[T]:
    # Dont use system.cmp because it is slower
    case order:
      of Ascending: comparison myRun[j] > temp
      of Descending: comparison myRun[j] < temp
  else:
    # use custom cmp()
    case order:
      of Ascending: comparison cmp(myRun[j], temp) == 1
      of Descending: comparison cmp(myRun[j], temp) == -1

proc merge[T](a, b: var openArray[T], lo, m, hi: int,
              cmp: proc (x, y: T): int {.closure.},
                  order: SortOrder) {.effectsOf: cmp.} =
  # Optimization: If max(left) <= min(right) there is nothing to do!
  if cmp(a[m], a[m+1]) * order <= 0: return
  var j = lo
  # copy a[j..m] into b:
  assert j <= m

  var bb = 0
  while j <= m:
    b[bb] <- a[j]
    inc(bb)
    inc(j)
  var i = 0
  var k = lo

  # copy proper element back:
  template comparison(body: untyped) =
    while k < j and j <= hi:
      if body:
        a[k] <- b[i]
        inc(i)
      else:
        a[k] <- a[j]
        inc(j)
      inc(k)

  if cmp == system.cmp[T]:
    # Dont use system.cmp because it is slower
    case order:
      of Ascending: comparison b[i] <= a[j]
      of Descending: comparison b[i] >= a[j]
  else:
    # use custom cmp()
    comparison cmp(b[i], a[j]) * order <= 0
  # copy rest of b:
  while k < j:
    a[k] <- b[i]
    inc(k)
    inc(i)

proc mergeIndex[T](a, b: var openArray[T], bidx: var seq[int], lo, m, hi: int,
                  cmp: proc (x, y: T): int {.closure.},
                  order: SortOrder, idx: var seq[int]) {.effectsOf: cmp.} =

  # Optimization: If max(left) <= min(right) there is nothing to do!
  if cmp(a[m], a[m+1]) * order <= 0: return
  var j = lo
  # copy a[j..m] into b:
  assert j <= m

  var bb = 0
  while j <= m:
    b[bb] <- a[j]
    bidx[bb] <- idx[j]
    inc(bb)
    inc(j)
  var i = 0
  var k = lo

  # copy proper element back:
  template comparison(body: untyped) =
    while k < j and j <= hi:
      if body:
        a[k] <- b[i]
        idx[k] <- bidx[i]
        inc(i)
      else:
        a[k] <- a[j]
        idx[k] <- idx[j]
        inc(j)
      inc(k)

  if cmp == system.cmp[T]:
    # Dont use system.cmp because it is slower
    case order:
      of Ascending: comparison b[i] <= a[j]
      of Descending: comparison b[i] >= a[j]
  else:
    # use custom cmp()
    comparison cmp(b[i], a[j]) * order <= 0
  # copy rest of b:
  while k < j:
    a[k] <- b[i]
    idx[k] <- bidx[i]
    inc(k)
    inc(i)

func timSort*[T](arr: var openArray[T], cmp: proc (x,
    y: T): int {.closure.}, order = SortOrder.Ascending) {.effectsOf: cmp.} =
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
  var b = newSeq[T](n)
  for i in countup(0, n - 1, RUN):
    insertionSort(arr, i, min(i + RUN - 1, n-1), cmp, order)

  var size: int = RUN
  while size < n:
    for left in countup(0, n-1, 2*size):
      var
        mid = left + size - 1
        right = min(left + 2 * size - 1, n - 1)
      if mid < right:
        merge(arr, b, left, mid, right, cmp, order)
    size *= 2

proc timSort*[T](arr: var openArray[T], order = SortOrder.Ascending) =
  timSort[T](arr, system.cmp[T], order)

func timSort*[T](arr: var seq[seq[T]], cmp: proc (x, y: T): int {.closure.},
    order: SortOrder, sortIndex: varargs[int]) {.effectsOf: cmp.} =
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


  let n = arr[0].len
  var 
    input = arr
    idx = newSeq[int](n)
    b = newSeq[T](n)
    bidx = newSeq[int](n)
  for i in 0..<arr[0].len:
    idx[i] = i

  for col in countdown(sortIndex.len - 1, 0, 1):
    for i in countup(0, n - 1, RUN):
      insertionSortIndex(arr[sortIndex[col]], i, min(i + RUN - 1, n-1), cmp,
          order, idx)

    var size: int = RUN
    while size < n:
      for left in countup(0, n-1, 2*size):
        var
          mid = left + size - 1
          right = min(left + 2 * size - 1, n - 1)
        if mid < right:
          mergeIndex(arr[sortIndex[col]], b, bidx, left, mid, right, cmp,
              order, idx)
      size *= 2

    #use idx[] to rebuild data
    for column in 0..<arr.len:
      if sortIndex[col] == column: continue
      for index, row in idx:
        arr[column][index] = input[column][row]

proc timSort*[T](arr: var seq[seq[T]], sortIndex: varargs[int] = [0]) =
  timSort[T](arr, system.cmp[T], Ascending, sortIndex)
