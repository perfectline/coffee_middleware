class CoffeeMiddleware.System.Base

  # Bind many elements, each to its own class
  @bindMany: (selector) ->
    collection = []
    instance = @

    if $(selector).length > 0
      $(selector).each ->
        collection.push(new instance($(@)))

    collection

  # Force only single element
  @bindOne: (selector) ->
    if $(selector).length > 0
      new @($(selector))

  # Bind a collection of elements
  @bindCollection: (selector) ->
    if $(selector).length > 0
      new @($(selector))


  reBind: =>
    @.constructor(@.container)

  constructor: (@container) ->