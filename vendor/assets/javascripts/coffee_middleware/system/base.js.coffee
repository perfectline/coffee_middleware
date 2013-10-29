class CoffeeMiddleware.System.Base
  @subscribeTo: []
  @selector:    null
  @bindMethod:  'bindMany'
  @scope:       document
  @caching:     true

  # Bind many elements, each to its own class
  @bindMany: (selector, context = null) ->
    collection = []
    instance = @

    if $(selector, context).length > 0
      $(selector, context).each (index, element) =>
        el = $(element)
        if @caching
          unless @addToCache(instance.name, element)
            collection.push(new instance(el))
        else
          collection.push(new instance(el))

    collection

  # Force only single element
  @bindOne: (selector, context = null) ->
    if $(selector, context).length > 0
      el = $(selector, context)
      if @caching
        unless @addToCache(@.name, el[0])
          new @(el)
      else
        new @(el)

  # Bind a collection of elements
  @bindCollection: (selector, context = null) ->
    if $(selector, context).length > 0
      el = $(selector, context)
      if @caching
        unless @addToCache(@.name, el[0])
          new @(el)
      else
        new @(el)

  # Initalize this componet: Will apply this class to the @selector, using the bindMethod selected
  @init: =>
    if @selector
      @[@bindMethod].apply(@, [@selector])
      @handleSubscriptions()

  # add listeners to the @subscribeTo events, to reinitalize
  @handleSubscriptions: =>
    for event in @subscribeTo
      ($ @scope).on event, (e) =>
        @[@bindMethod].apply(@, [@selector, e.target])


  @addToCache: (name, element) =>
    unless CoffeeMiddleware.Cache[name]
      CoffeeMiddleware.Cache[name] = []
    unless @cacheContains(name, element)
      CoffeeMiddleware.Cache[name].push element
      return true
    false

  @forceCache: (name, element) =>
    index = CoffeeMiddleware.Cache[name].indexOf(element)
    if index == -1
      @addToCache(name, element)
    else
      CoffeeMiddleware.Cache[name][index] = element

  @cacheContains: (name, element) =>
    element in CoffeeMiddleware.Cache[name]

  reBind: =>
    @.constructor(@.container)

  constructor: (@container) ->