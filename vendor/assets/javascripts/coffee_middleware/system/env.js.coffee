class CoffeeMiddleware.System.Env
  constructor: ->
    @successStatus = "success"

  setSuccessStatus: (name) =>
    @successStatus = name

  getSuccessStatus: =>
    @successStatus