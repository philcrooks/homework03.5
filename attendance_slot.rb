require_relative('models/team')

class AttendanceSlot

  attr_reader :team, :results, :home_games, :attendance, :average_attendance

  def AttendanceSlot.header
    return "%-30s  %5s  %10s  %10s  %10s" % ["", "Games", "Attendance", "%Capacity", "Average"]
  end

  def initialize(team)
    @team = team
    @results = []
    @home_games = 0
    @attendance = 0
    @average_attendance = 0
    @capacity = 0
  end

  def << (result)
    @home_games += 1
    @attendance += result.fixture.attendance
    @average_attendance = @attendance / @home_games
    @capacity += result.fixture.ground.capacity
    @results << result
  end

  def <=> (neighbour)
    @average_attendance <=> neighbour.average_attendance
  end

  def to_s
    return "%-30s  %5d  %10d  %10d  %10d" % ["#{@team} (#{team.country})", @home_games, @attendance, (@attendance * 100) / @capacity, @average_attendance]
  end
end