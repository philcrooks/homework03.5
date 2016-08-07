require_relative ('League')
require_relative ('pro12_league')
require_relative ('pro12_slot')

class Pro12League < League

  def Pro12League.header
    return League.header + Pro12Slot.header
  end

  def << (team)
    # Add a team to the league
    @slots << Pro12Slot.new(team)
  end
end