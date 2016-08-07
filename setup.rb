require('pry-byebug')
require_relative ('db/sql_runner')
require_relative ('models/ground')
require_relative ('models/team')
require_relative ('models/referee')
require_relative ('models/country')
require_relative ('models/fixture')

def delete_all
  Fixture.delete_all
  Referee.delete_all
  Ground.delete_all
  Team.delete_all
  Country.delete_all
end

def setup_countries
  scotland = Country.new({'name' => 'Scotland'})
  ireland =Country.new({'name' => 'Ireland'})
  wales =Country.new({'name' => 'Wales'})
  italy =Country.new({'name' => 'Italy'})
  scotland.save # 1
  ireland.save  # 2
  wales.save    # 3
  italy.save    # 4
end

def gr (name, city, country_id, capacity)
  return {'name' => name, 'city' => city, 'country_id' => country_id, 'capacity' => capacity}
end

def setup_grounds
  grounds = []
  grounds << Ground.new(gr('Stadio Comunale di Monigo', 'Treviso', 4, 6700))
  grounds << Ground.new(gr('Cardiff Arms Park', 'Cardiff', 3, 12500))
  grounds << Ground.new(gr('Galway Sportsgrounds', 'Galway', 2, 9500))
  grounds << Ground.new(gr('Murrayfield Stadium', 'Edinburgh', 1, 12500))
  grounds << Ground.new(gr('Scotstoun Stadium', 'Glasgow', 1, 10000))
  grounds << Ground.new(gr('RDS Arena', 'Dublin', 2, 18500))
  grounds << Ground.new(gr('Aviva Stadium', 'Dublin', 2, 51700))
  grounds << Ground.new(gr('Thomond Park', 'Limerick', 2, 25600))
  grounds << Ground.new(gr('Musgrave Park', 'Cork', 2, 9251))
  grounds << Ground.new(gr('Rodney Parade', 'Newport',3, 11676))
  grounds << Ground.new(gr('Liberty Stadium', 'Swansea', 3, 20532))
  grounds << Ground.new(gr('Parc y Scarlets', 'Llanelli', 3, 14870))
  grounds << Ground.new(gr('Kingspan Stadium', 'Belfast', 2, 18196))
  grounds << Ground.new(gr('Stadio XXV Aprile', 'Parma', 4, 5000))
  grounds.each { | ground | ground.save }
  return grounds
end

def tm (name, city, country_id)
  return {'name' => name, 'city' => city, 'country_id' => country_id}
end

def setup_teams
  teams = []
  teams << Team.new(tm('Benetton Treviso', 'Treviso', 4))
  teams << Team.new(tm('Cardiff Blues', 'Cardiff', 3))
  teams << Team.new(tm('Connacht', 'Galway', 2))
  teams << Team.new(tm('Edinburgh', 'Edinburgh', 1))
  teams << Team.new(tm('Glasgow Warriors', 'Glasgow', 1))
  teams << Team.new(tm('Leinster', 'Leinster (region)', 2))
  teams << Team.new(tm('Munster', 'Munster (region)', 2))
  teams << Team.new(tm('Newport Gwent Dragons', 'Newport', 3))
  teams << Team.new(tm('Ospreys', 'Swansea', 3))
  teams << Team.new(tm('Scarlets', 'Llanelli', 3))
  teams << Team.new(tm('Ulster', 'Belfast', 2))
  teams << Team.new(tm('Zebre', 'Parma', 4))

  teams.each { | team | team.save }
  return teams
end

def rf (name, country_id)
  return {'name' => name, 'country_id' => country_id}
end

def setup_referees
  referees = []
  referees << Referee.new(rf('Leighton Hodges', 3))
  referees << Referee.new(rf('David Wilkinson', 2))
  referees << Referee.new(rf('Peter Fitzgibbon', 2))
  referees << Referee.new(rf('Marius Mitrea', 4))
  referees << Referee.new(rf('Nigel Owens', 3))
  referees << Referee.new(rf('Andrew McMenemy', 1))
  referees << Referee.new(rf('Gary Conway', 2))
  referees << Referee.new(rf('John Lacey', 2))
  referees << Referee.new(rf('Ian Davies', 3))
  referees << Referee.new(rf('Neil Paterson', 1))
  referees << Referee.new(rf('Matteo Liperini', 4))
  referees << Referee.new(rf('Claudio Blessano', 4))
  referees << Referee.new(rf('Dudley Phillips', 2))
  referees << Referee.new(rf('Neil Hennessy', 3))
  referees << Referee.new(rf('Lloyd Linton', 1))
  referees << Referee.new(rf('George Clancy', 2))
  referees << Referee.new(rf('Ben Whitehouse', 3))
  referees << Referee.new(rf('Leo Colgan', 2))
  referees.each { | ref | ref.save }
  return referees
end

def fx(home_id, away_id, ground_id, referee_id, round_no, home_score, away_score, home_tries, away_tries, attendance)
  return {'home_team_id' => home_id, 'away_team_id' => away_id, 'ground_id' => ground_id, 'referee_id' => referee_id, 'round_no' => round_no, 'home_score' => home_score, 'away_score' => away_score, 'home_try_count' => home_tries, 'away_try_count' => away_tries, 'attendance' => attendance}
end

def setup_fixtures
  fixtures = []
  # round 1
  fixtures << Fixture.new(fx(  7,  4,  8,  1,  1, 13, 14, 2, 1, 13428 ))
  fixtures << Fixture.new(fx(  9,  1, 11,  2,  1, 44, 13, 5, 1, 6213 ))
  fixtures << Fixture.new(fx( 10, 11, 12,  3,  1, 32, 32, 4, 4, 6531 ))
  fixtures << Fixture.new(fx(  3,  8,  3,  4,  1, 16, 11, 2, 1, 4123 ))
  fixtures << Fixture.new(fx(  5,  6,  5,  5,  1, 22, 20, 3, 2, 5725 ))
  fixtures << Fixture.new(fx( 12,  2, 14,  6,  1, 26, 41, 3, 5, 2800 ))
  # round 2
  fixtures << Fixture.new(fx(  1,  7,  1,  6,  2, 10, 21, 1, 2, 3491 ))
  fixtures << Fixture.new(fx(  4,  3,  4,  7,  2, 13, 14, 1, 1, 3777 ))
  fixtures << Fixture.new(fx(  8,  9, 10,  5,  2, 15, 17, 0, 2, 7199 ))
  fixtures << Fixture.new(fx( 11, 12, 13,  1,  2, 33, 13, 5, 1, 13835 ))
  fixtures << Fixture.new(fx(  6, 10,  6,  4,  2, 42, 12, 6, 2, 16108 ))
  fixtures << Fixture.new(fx(  2,  5,  2,  8,  2, 12, 33, 0, 3, 6897 ))
  # round 3
  fixtures << Fixture.new(fx(  7, 12,  8,  9,  3, 31,  5, 5, 1, 12488 ))
  fixtures << Fixture.new(fx(  2, 11,  2, 10,  3,  9, 26, 0, 2, 7041 ))
  fixtures << Fixture.new(fx(  3,  6,  3,  8,  3, 10,  9, 1, 0, 5917 ))
  fixtures << Fixture.new(fx(  8,  5, 10,  2,  3, 13, 33, 1, 4, 5885 ))
  fixtures << Fixture.new(fx( 10,  1, 12, 11,  3, 43,  0, 7, 0, 5791 ))
  fixtures << Fixture.new(fx(  9,  4, 11,  3,  3, 62, 13, 9, 1, 6340 ))
  # round 4
  # home, away, ground, ref, round, h_score, a_score, h_tries, a_tries, attend
  fixtures << Fixture.new(fx(  4, 10,  4,  8,  4, 20, 20, 2, 2, 3328 ))
  fixtures << Fixture.new(fx(  5,  3,  5, 12,  4, 39, 21, 5, 3, 5821 ))
  fixtures << Fixture.new(fx(  6,  2,  6,  9,  4, 37, 23, 4, 2, 12540 ))
  fixtures << Fixture.new(fx( 12, 11, 14, 13,  4, 13,  6, 1, 0, 2269 ))
  fixtures << Fixture.new(fx(  7,  9,  8, 14,  4, 14, 19, 1, 1, 13547 ))
  fixtures << Fixture.new(fx(  8,  1, 10,  6,  4, 33, 15, 4, 2, 5162 ))
  # round 5
  # home, away, ground, ref, round, h_score, a_score, h_tries, a_tries, attend
  fixtures << Fixture.new(fx(  3,  2,  3, 10,  5, 24, 24, 3, 3, 5247 ))
  fixtures << Fixture.new(fx( 11,  4, 13, 12,  5, 30,  0, 4, 0, 15479 ))
  fixtures << Fixture.new(fx( 12,  9, 14, 15,  5, 14, 15, 1, 0, 2812 ))
  fixtures << Fixture.new(fx(  6,  7,  7,  9,  5, 23, 24, 2, 3, 43817 ))
  fixtures << Fixture.new(fx(  1,  5,  1,  7,  5, 23, 40, 2, 5, 2382 ))
  fixtures << Fixture.new(fx( 10,  8, 12, 16,  5, 26, 13, 2, 1, 7124 ))
  # round 6
  # home, away, ground, ref, round, h_score, a_score, h_tries, a_tries, attend
  fixtures << Fixture.new(fx(  1,  3,  1,  2,  6,  6,  9, 0, 0, 3025 ))
  fixtures << Fixture.new(fx(  7, 10,  8, 12,  6, 17,  6, 1, 0, 13851 ))
  fixtures << Fixture.new(fx(  4,  8,  4, 13,  6, 24, 10, 2, 1, 3156 ))
  fixtures << Fixture.new(fx( 12,  6, 14, 10,  6,  3, 20, 0, 2, 2518 ))
  fixtures << Fixture.new(fx( 11,  5, 13,  5,  6, 29,  9, 2, 0, 16260 ))
  fixtures << Fixture.new(fx(  9,  2, 11,  1,  6, 26, 15, 2, 2, 10821 ))
  # round 7
  # home, away, ground, ref, round, h_score, a_score, h_tries, a_tries, attend
  fixtures << Fixture.new(fx(  5,  1,  5,  9,  7, 17,  9, 1, 0, 5901 ))
  fixtures << Fixture.new(fx(  6,  4,  6,  5,  7, 33,  8, 5, 1, 15077 ))
  fixtures << Fixture.new(fx(  9,  3, 11,  8,  7, 26, 11, 2, 1, 6010 ))
  fixtures << Fixture.new(fx(  2,  7,  2,  4,  7, 24, 28, 2, 1, 6902 ))
  fixtures << Fixture.new(fx( 10, 12, 12,  7,  7, 28, 13, 1, 1, 5342 ))
  fixtures << Fixture.new(fx( 11,  8, 13, 11,  7, 23,  6, 3, 0, 13501 ))
  # round 8
  # home, away, ground, ref, round, h_score, a_score, h_tries, a_tries, attend
  fixtures << Fixture.new(fx(  8,  7, 10, 11,  8, 12, 38, 0, 4, 5783 ))
  fixtures << Fixture.new(fx(  3, 12,  3, 17,  8, 43,  3, 5, 0, 5486 ))
  fixtures << Fixture.new(fx( 10,  5, 12,  2,  8, 19,  9, 1, 0, 6038 ))
  fixtures << Fixture.new(fx( 11,  9, 13, 14,  8, 25, 16, 3, 1, 16923 ))
  fixtures << Fixture.new(fx(  1,  6,  1, 10,  8, 24, 24, 4, 4, 2851 ))
  fixtures << Fixture.new(fx(  4,  2,  4, 18,  8, 28, 13, 3, 1, 3803 ))
  # round 9
  # home, away, ground, ref, round, h_score, a_score, h_tries, a_tries, attend
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  # round 10
  # home, away, ground, ref, round, h_score, a_score, h_tries, a_tries, attend
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  # fixtures << Fixture.new(fx( , , , , , , , , , ))
  fixtures.each { | fixture | fixture.save }
  return fixtures
end

def setup_all
  # Order is important
  # Countries must be created first and fixtures last
  setup_countries
  setup_teams
  setup_grounds
  setup_referees
  setup_fixtures
end

def show_sql
  requests = SqlRunner.requests
  requests.each { | request | puts "#{request}" }
end


binding.pry
nil