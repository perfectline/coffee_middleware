class CoffeeMiddleware.Component.JsonForm extends CoffeeMiddleware.System.Base
  constructor: (@container, @autoAction = true) ->
    super(@container)
    if @container.is 'form'
      @form = @container
    else
      @form = ($ 'form', @container)

    if @form[0]
      @initForm()

  initForm: =>
    @form.on "ajax:success",     @handleResponse
    @form.on "response:success", @completeForm
    @form.on "response:error",   @updateForm
    @form.on "response:cancel",  @cancelForm

    @form.on 'submit', (e) =>
      e.preventDefault()
      e.stopPropagation()
      @form.trigger("submit.rails")

    @cancelButton = @form.find("*[data-action='cancel']")
    @cancelButton.on "click", =>
      @form.trigger("response:cancel")

  handleResponse: (event, json) =>
    if json.completed
      @form.trigger 'response:success', json
    else
      @form.trigger 'response:error', json

  completeForm: (event, json) =>
    if @autoAction
      if json.redirect
        if json.redirect == 'root'
          window.top.location = '/'
        else
          window.top.location = json.redirect
      else if json.template
        @form = $(json.template).replaceAll(@form)
        @initForm()
        @form.trigger('jsonForm:completed')
    else
      @form.trigger('jsonForm:completed')

  updateForm: (event, json) =>
    if @autoAction
      @form = $(json.template).replaceAll(@form)
      @initForm()
    @form.trigger('jsonForm:updated')

  cancelForm:  =>
    @container.remove()
