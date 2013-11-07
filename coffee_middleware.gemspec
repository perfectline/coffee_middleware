# coding: utf-8

$:.push File.expand_path("../lib", __FILE__)

require "coffee_middleware/version"

Gem::Specification.new do |spec|
  spec.name          = "coffee_middleware"
  spec.version       = CoffeeMiddleware::VERSION
  spec.authors       = ["Juri Semjonov", "Meiko Udras"]
  spec.email         = ["juri.semjonov@gmail.com", "meiko.udras@perfectline.co"]
  spec.summary       = %q{Coffee Middleware}
  spec.description   = %q{Coffee Middleware}
  spec.homepage      = "https://github.com/perfectline/coffee_middleware"
  spec.license       = "MIT"

  spec.files = Dir["{lib}/**/*"] + Dir["vendor/**/*"] + ["Rakefile", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency("coffee-script")
  spec.add_dependency("jquery-rails")

  spec.add_dependency "rake"
end
