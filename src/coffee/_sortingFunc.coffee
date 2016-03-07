class SortingFuncGenerator
  constructor: (@action, @arr) ->
  dump: () ->
    [
      # new InsertSort(@action, @arr)
      new HeapSort(@action, @arr)
      new SelectionSort(@action, @arr)
      new BubbleSort(@action, @arr)
      new QuickSort(@action, @arr)
      # new WierdSort(@action, @arr)
    ]

class SortingFunc
  constructor: (@action, @arr) ->

  run: () =>
    @

  nextStage: () =>
    @action.nextStage()

  swap: (i, j) =>
    return if i is j
    t = @arr[i]
    @arr[i] = @arr[j]
    @arr[j] = t
    @action.push
      type: 'swap'
      m: i
      n: j

  pivot: (i) =>
    @action.push
      type: 'pivot'
      val: i

class InsertSort extends SortingFunc
  run: () =>
    for i in [1...@arr.length]
      t = -1
      for j in [i-1..0]
        if @arr[i] > @arr[j]
          t = j
          break
      for k in [i-1...j]
        @swap k, k+1
    for i in [0...@arr.length]
      @pivot i

class HeapSort extends SortingFunc
  maxify: (i, len) =>
    largest = i
    return if i*2 >= len

    if i*2 is len-1
      if @arr[i*2] > @arr[i]
        @swap i, i*2
      return
    if @arr[i*2] > @arr[largest]
      largest = i*2
    if @arr[i*2+1] > @arr[largest]
      largest = i*2+1

    return if largest is i
    @swap i, largest
    @maxify largest, len

  run: () =>
    for i in [~~(@arr.length/2)..0]
      @maxify i, @arr.length

    for i in [@arr.length-1...0]
      @swap 0, i
      @pivot i
      @maxify 0, i
    @pivot 0

class SelectionSort extends SortingFunc
  run: () =>
    for i in [0...@arr.length]
      min = Math.min()
      p = 0
      for j in [i...@arr.length]
        if @arr[j] < min
          min = @arr[j]
          p = j
      @swap i, p
      @pivot i

class BubbleSort extends SortingFunc
  run: () =>
    for i in [@arr.length-1..0]
      for j in [0...i]
        if @arr[i] < @arr[j]
          @swap i, j
      @pivot i

class QuickSort extends SortingFunc
  run: () =>
    @iter(0, @arr.length-1)

  iter: (start, end) =>
    if start is end
      @pivot start
      return
    i = start
    j = end
    for k in [i..j]
      if @arr[k] < @arr[j]
        @swap k, i
        ++i
    @swap j, i
    @pivot i
    @iter(start, i-1) if start < i
    @iter(i+1, end) if i < end

# only for [0...n]
class WierdSort extends SortingFunc
  run: () =>
    for i in [0...@arr.length]
      continue if @arr[i] is i
      while @arr[i] isnt i
        @pivot i
        @swap i, @arr[i]
      @pivot i

exports = module.exports = SortingFuncGenerator
