require('pry-byebug')
require_relative ('models/ground')
require_relative ('models/team')
require_relative ('models/referee')
require_relative ('models/country')
require_relative ('models/fixture')

fixtures = Fixture.all
fixtures.each { | fixture | puts "#{fixture}\n"}
binding.pry
nil