require_relative ('league')
require_relative ('attendance_league')
require_relative ('attendance_slot')

class AttendanceLeague < League

  def AttendanceLeague.header
    return League.header + AttendanceSlot.header
  end

  def << (team)
    # Add a team to the league
    @slots << AttendanceSlot.new(team)
  end

  def add_result (result)
    slot = find_team_slot(result.team)
    slot << result if slot
  end
end