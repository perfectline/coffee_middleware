CoffeeScript Middleware
=======================

This is a small CoffeeScript library to make binding your CoffeeScript classes to dom elements easier. 
It offers a helper class for using remote forms with rails and tries to make them more managable.

Getting Started
===============

Create application/application.js file in your app/assets/javascripts directory

Add directories 'models' and 'views' in your app/assets/javascripts/application directory

In the application.js file add this. Replacing ApplicationName with the name of your application.

```coffeescript
#= require_self
#= require_tree ./models
#= require_tree ./views

window.ApplicationName = {
  Models: {}
  Views:  {}
}
```

To create a view that binds to a dom element create it in the views directory, 
for example: example_view.js.coffee

```coffeescript
class ApplicationName.Views.ExampleView extends CoffeeMiddleware.System.Base
  # list event to subscribe to, and in the event context try to reinitialize this view
  @subscribeTo: []
  # selector that corresponds to this view
  @selector:    "*[data-example-view]"
  # binding method, options are: bindOne, bindMany, bindCollection
  @bindMethod:  'bindMany'
  # default scope, where to look for
  @scope:       document
  # use caching, that means one dom element will get bound only once to a class
  @caching:     true

  constructor: (@container) ->
    # Do things with the @container here, @container is a jQuery object that corresponds to the selector
    
$ ->
  ApplicationName.Views.ExampleView.init()
```

* **@subscribeTo**: Events this view should listen to. When the event is triggered, it will automatically 
try to find the selector and bind with the event.currentTarget context. Which means, when you have custom scripting
for an element and you replace that element and trigger an event after replacing it from somewhere else all the custom
scripting can be automatically rebound (e.g. submitting a form with custom selects, radios, checkboxes and doing server side
validation, then receiving it back with errors you can still keep the custom form elements without having to manually rebind the javascript)

* **@selector**: The selector which to bind this view to (required).

* **@bindMethod**: Options are: bindOne, bindMany, bindCollection.
  * **bindOne**: bind to one dom element, good to use with an id
  * **bindMany**: bind to multiple dom elements, each dom element will have their own instance of the view
  * **bindCollection**: bind to a collection of dom elements, if you need to manage multiple dom elements in a single view

* **@scope**: The context within where to bind, default is document

* **@caching**: Whether to use caching or not. This means whether a dom element should have only a single instance of a view bound to it. (stops multiple binding). Does not prevent binding different views to the same element.


JSON Form
=========

An example JSON form

```coffeescript
class ApplicationName.Views.ExampleForm extends CoffeeMiddleware.Component.JsonForm
  @selector: '*[data-json-form]'
  constructor: (@container) ->
    super

  completeForm: (event, json) =>
    super

  updateForm: (event, json) =>
    super

$ ->
  ApplicationName.Views.ExampleForm.init()
```

Triggers completeForm when the JSON response for the remote form contain completed: true. Which means the submit was successful.
If the JSON response also contains redirect then it will redirect to the URL there. Otherwise if it contains template it will replace
the form and trigger:
```
jsonForm:completed
```

If completed was set to false. It will assume there were validation errors and replace the form with the template it returns.
It will also trigger:
```
jsonForm:updated
```

Your action should look something like this:
```ruby
@resource = Resource.require(:resource).permit(:name, :description)  #if you want to only permit name and description
if @resource.save
  respond_to do |format|
    format.json { render json: { completed: true, redirect: home_path } }
  end
else
  respond_to do |format|
    format.json { render :json => {:completed => false, :template => render_to_string(:partial => 'form.html.haml', :locals => {:resource => @resource})} }
  end
end
```

