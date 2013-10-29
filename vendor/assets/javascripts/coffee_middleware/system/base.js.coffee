class CoffeeMiddleware.System.Base

  # Bind many elements, each to its own class
  @bindMany: (selector, context = null) ->
    collection = []
    instance = @

    if $(selector, context).length > 0
      $(selector, context).each ->
        collection.push(new instance($(@)))

    collection

  # Force only single element
  @bindOne: (selector, context = null) ->
    if $(selector, context).length > 0
      new @($(selector, context))

  # Bind a collection of elements
  @bindCollection: (selector, context = null) ->
    if $(selector, context).length > 0
      new @($(selector, context))


  reBind: =>
    @.constructor(@.container)

  constructor: (@container) ->