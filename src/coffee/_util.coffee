Util =
  # Fisher-Yates (aka Knuth) Shuffle
  shuffle: (array) ->
    currentIndex = array.length
    # While there remain elements to shuffle...
    while 0 isnt currentIndex
      # Pick a remaining element...
      randomIndex = ~~(Math.random() * currentIndex)
      --currentIndex
      # And swap it with the current element.
      tValue = array[currentIndex]
      array[currentIndex] = array[randomIndex]
      array[randomIndex] = tValue
    return array

  # event listener polyfill
  addEvent: (object, type, callback) ->
    return if object is null or typeof(object) is 'undefined'
    if object.addEventListener
      object.addEventListener type, callback, false
    else if object.attachEvent
      object.attachEvent "on" + type, callback
    else
      object["on"+type] = callback

  loopFunc: (delay, func) ->
    setInterval func, delay

exports = module.exports = Util
