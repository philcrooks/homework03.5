class Result

  attr_reader :win_lose_draw, :round_no, :team, :points_for, :points_against, :tries_for, :tries_against, :try_bonus, :losing_bonus, :fixture

  private

  def calc_result(points_for, points_against)
    diff = points_for - points_against
    return :draw if diff == 0
    return diff > 0 ? :win : :lose
  end

  public

  def Result.home_and_away(fixture)
    return [Result.new(fixture, :home), Result.new(fixture, :away)]
  end

  def initialize(fixture, home_or_away)
    if home_or_away == :home
      @team = fixture.home_team
      @points_for = fixture.home_score
      @points_against = fixture.away_score
      @tries_for = fixture.home_try_count
      @tries_against = fixture.away_try_count
      @try_bonus = fixture.home_try_count >= 4
    else
      @team = fixture.away_team
      @points_for = fixture.away_score
      @points_against = fixture.home_score
      @tries_for = fixture.away_try_count
      @tries_against = fixture.home_try_count
      @try_bonus = fixture.away_try_count >= 4
    end
    @win_lose_draw = calc_result( @points_for, @points_against )
    @losing_bonus = (win_lose_draw == :lose) && (@points_against - @points_for <= 7)
    @fixture = fixture
  end

end