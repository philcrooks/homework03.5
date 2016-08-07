require_relative('models/team')

class Pro12Slot

  attr_reader :team, :results, :played, :won, :drawn, :lost, :points_for, :points_against, :tries_for, :tries_against, :try_bonus, :losing_bonus, :points

  def initialize(team)
    @team = team
    @results = []
    @played = 0
    @won = 0
    @drawn = 0
    @lost = 0
    @points_for = 0
    @points_against = 0
    @tries_for = 0
    @tries_against = 0
    @try_bonus = 0
    @losing_bonus = 0
    @points = 0
  end

  def << (result)
    if result.team == @team
      @results << result
      @played = results.count
      @points_for += result.points_for
      @points_against += result.points_against
      @tries_for += result.tries_for
      @tries_against += result.tries_against
      @try_bonus += 1 if result.try_bonus
      @losing_bonus += 1 if result.losing_bonus
      case result.win_lose_draw
        when :win
          @won += 1
        when :lose
          @lost += 1
        when :draw
          @drawn += 1
      end
      @points = (@won * 4) + (@drawn * 2) + @try_bonus + @losing_bonus
    end
  end

  def <=> (neighbour)
    # In the event of a draw on points the following are considered in th 
    # 1. number of matches won
    # 2. the difference between points for and points against
    # 3. the number of tries scored
    # 4. the most points scored
    # 5. the difference between tries for and tries against
    result = @points <=> neighbour.points
    result = @won <=> neighbour.won if result == 0
    result = points_difference <=> neighbour.points_difference if result == 0
    result = @tries_for <=> neighbour.tries_for if result == 0
    result = @points_for <=> neighbour.points_for if result == 0
    result = (@tries_for - @tries_against) <=> (neighbour.tries_for - neighbour.tries_against) if result == 0
    return result
  end

  def points_difference
    return @points_for - @points_against
  end

  def to_s
    return "%-22s %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d" % [@team, @played, @won, @drawn, @lost, @points_for, @points_against, points_difference, @try_bonus, @losing_bonus, @points]
  end

  def Pro12Slot.header
    return "%-22s %7s %7s %7s %7s %7s %7s %7s %7s %7s %7s" % ["", "Played", "Won", "Drawn", "Lost", "For", "Against", "Diff.", "Try", "Losing", "Points"]
  end

end