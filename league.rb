require_relative ('models/team')

class League

  attr_reader :slots

  private

  def find_team_slot(team)
    return @slots.find { | slot | slot.team == team }
  end

  public

  def initialize()
    @slots = []
  end

  def << (team)
    # Add a team to the league
    raise "The << method must be overridden"
  end

  def add_result (results)
    results.each do | result |
      slot = find_team_slot(result.team)
      slot << result if slot
    end
  end

  def sort
    @slots.sort! { | x, y | y <=> x }
  end

  def to_s
    # Print out the league table
    c = 1
    s = ""
    @slots.each do | slot |
      s += "%2d. #{slot}\n" % [c]
      c += 1
    end
    return s
  end

  def League.header
    return " " * 4
  end
end