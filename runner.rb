require('pry-byebug')
require_relative ('db/sql_runner')
require_relative ('models/ground')
require_relative ('models/team')
require_relative ('models/referee')
require_relative ('models/country')
require_relative ('models/fixture')
require_relative ('result')
require_relative ('pro12_league')
require_relative ('pro12_slot')
require_relative ('attendance_league')
require_relative ('attendance_slot')

pro12_league = Pro12League.new()
attendance_league = AttendanceLeague.new()
teams = Team.all
teams.each do  | team | 
  pro12_league << team
  attendance_league << team
end

round = 1
fixtures = Fixture.in_round(round)
while fixtures.count > 0
  fixtures.each do | match |
    puts "#{match}"
    puts
    result = Result.home_and_away(match)
    pro12_league.add_result(result)
    attendance_league.add_result(result.first)
  end
  pro12_league.sort
  puts "Pro12 League Table After Round #{round}:"
  puts "#{Pro12League.header}"
  puts "#{pro12_league}"
  puts
  print "Hit 'Enter' to continue:"
  gets
  puts
  round += 1
  fixtures = Fixture.in_round(round)
end
puts "That's the end of the season."
puts
attendance_league.sort
puts "Home attendence after #{round-1} rounds:"
puts "#{AttendanceLeague.header}"
puts "#{attendance_league}"
puts
print "Hit 'Enter' to continue:"
gets
puts
requests = SqlRunner.requests
requests.each { | request | puts "#{request}" }