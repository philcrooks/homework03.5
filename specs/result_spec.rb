require ('minitest/autorun')
require ('minitest/rg')
require_relative ('../models/fixture')
require_relative ('../result')

class TestResult < Minitest::Test
  def setup
    @match = Fixture.all.first # Munster 13 v 14 Edinburgh
  end

  def test_new_result
    result = Result.new(@match, :home)
    assert_equal("Munster", result.team.name)
    assert_equal(13, result.points_for)
    assert_equal(14, result.points_against)
    assert_equal(2, result.tries_for)
    assert_equal(1, result.tries_against)
    assert_equal(:lose, result.win_lose_draw)
    assert_equal(false, result.try_bonus)
    assert_equal(true, result.losing_bonus)
  end

  def test_home_and_away
    result = Result.home_and_away(@match)
    assert_equal("Munster", result[0].team.name)
    assert_equal("Edinburgh", result[1].team.name)
    assert_equal(14, result[1].points_for)
    assert_equal(13, result[1].points_against)
    assert_equal(1, result[1].tries_for)
    assert_equal(2, result[1].tries_against)
    assert_equal(:win, result[1].win_lose_draw)
    assert_equal(false, result[1].try_bonus)
    assert_equal(false, result[1].losing_bonus)
  end

end