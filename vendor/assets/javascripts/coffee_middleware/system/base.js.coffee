class CoffeeMiddleware.System.Base
  @subscribeTo: []
  @selector:    null
  @bindMethod:  'bindMany'
  @scope:       document

  # Bind many elements, each to its own class
  @bindMany: (selector, context = null) ->
    collection = []
    instance = @
    if $(selector, context).length > 0
      $(selector, context).each (index, element) =>
        el = $(element)
        collection.push(new instance(el))

    collection

  # Force only single element
  @bindOne: (selector, context = null) ->
    if $(selector, context).length > 0
      el = $(selector, context)
      new @(el)

  # Bind a collection of elements
  @bindCollection: (selector, context = null) ->
    if $(selector, context).length > 0
      el = $(selector, context)
      new @(el)

  # Initalize this componet: Will apply this class to the @selector, using the bindMethod selected
  @init: (@subscribeTo = @subscribeTo, @selector = @selector, @bindMethod = @bindMethod, @scope = @scope) =>
    if @selector
      @[@bindMethod].apply(@, [@selector])
      @handleSubscriptions(@subscribeTo, @selector, @bindMethod, @scope)

  # add listeners to the @subscribeTo events, to reinitalize
  @handleSubscriptions: (@subscribeTo, @selector, @bindMethod, @scope) =>
    for event in @subscribeTo
      ($ @scope).on event, (e) =>
        @[@bindMethod].apply(@, [@selector, e.target])


  reBind: =>
    @.constructor(@.container)

  constructor: (@container) ->