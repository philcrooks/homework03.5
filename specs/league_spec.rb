require ('minitest/autorun')
require ('minitest/rg')
require_relative ('../result')
# require_relative ('../league')
require_relative ('../pro12_league')
require_relative ('../models/team')
require_relative ('../models/fixture')

class TestResult < Minitest::Test
  def setup
    @league = Pro12League.new
    @teams = Team.all
    @fixtures = Fixture.in_round(1)
    @result = Result.home_and_away(@fixtures.first)
  end

  def test_empty_league
    assert_equal(0, @league.slots.count)
  end

  def test_add_one_team
    @league << @teams[3] # Edinburgh
    assert_equal(1, @league.slots.count)
    assert_equal(@league.slots[0].team.name, "Edinburgh")
  end

  def test_add_one_result
    @league << @teams[3]
    @league.add_result(@result)
    assert_equal(1, @league.slots[0].played)
    assert_equal(@result.last, @league.slots[0].results[0])
    assert_equal(1, @league.slots[0].won)
    assert_equal(0, @league.slots[0].drawn)
    assert_equal(0, @league.slots[0].lost)
    assert_equal(14, @league.slots[0].points_for)
    assert_equal(13, @league.slots[0].points_against)
    assert_equal(1, @league.slots[0].tries_for)
    assert_equal(2, @league.slots[0].tries_against)
    assert_equal(0, @league.slots[0].try_bonus)
    assert_equal(0, @league.slots[0].losing_bonus)
    assert_equal(4, @league.slots[0].points)
  end

  def test_add_all_teams
    @teams.each { | team | @league << team }
    assert_equal(12, @league.slots.count)
  end

  def test_add_round_1_results
    @teams.each { | team | @league << team }
    @fixtures.each { | fixture | @league.add_result(Result.home_and_away(fixture)) }
    @league.slots.each { | slot | assert_equal(1, slot.played) }
  end

  def test_league_sort
    @teams.each { | team | @league << team }
    @fixtures.each { | fixture | @league.add_result(Result.home_and_away(fixture)) }
    @league.sort
    c = 0 
    while c < @league.slots.count - 1
      result = @league.slots[c].points >= @league.slots[c + 1].points
      assert_equal(true, result)
      c += 1
    end
  end

end