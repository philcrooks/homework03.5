require_relative ('../db/sql_runner')
require_relative ('ground')
require_relative ('referee')
require_relative ('team')

class Fixture

  attr_reader :id
  attr_accessor :home_team, :away_team, :ground, :referee, :round_no, :home_score, :away_score, :home_try_count, :away_try_count, :attendance

  private

  def Fixture.retrieve_from_db
    sql = "SELECT * FROM fixtures"
    result = SqlRunner.run(sql)
    return result.map { | options | Fixture.new(options) }
  end

  public

  def Fixture.delete_all
    begin
      sql = "DELETE FROM fixtures"
      SqlRunner.run(sql)
      @@fixtures = []
    rescue
    end
  end

  def Fixture.all
    @@fixtures ||= Fixture.retrieve_from_db
    return @@fixtures
  end

  def Fixture.find_by_id(id)
    @@fixtures ||= Fixture.retrieve_from_db
    return @@fixtures.find { | fixture | fixture.id == id }
  end

  def Fixture.in_round(round_no)
    @@fixtures ||= Fixture.retrieve_from_db
    return @@fixtures.select { | fixture | fixture.round_no == round_no }
  end

  def initialize(options)
    # @options = options
    @id = options['id'].to_i
    @home_team = Team.find_by_id(options['home_team_id'].to_i)
    @away_team = Team.find_by_id(options['away_team_id'].to_i)
    @ground = Ground.find_by_id(options['ground_id'].to_i)
    @referee = Referee.find_by_id(options['referee_id'].to_i)
    @round_no = options['round_no'].to_i
    @home_score = options['home_score'].to_i
    @away_score = options['away_score'].to_i
    @home_try_count = options['home_try_count'].to_i
    @away_try_count = options['away_try_count'].to_i
    @attendance = options['attendance'].to_i
  end

  def save
    begin
      @@fixtures ||= Fixture.retrieve_from_db
      sql = "INSERT INTO fixtures (home_team_id, away_team_id, ground_id, referee_id, round_no, home_score, away_score, home_try_count, away_try_count, attendance) VALUES (#{@home_team.id}, #{@away_team.id}, #{@ground.id}, #{@referee.id}, #{@round_no}, #{@home_score}, #{@away_score}, #{@home_try_count}, #{@away_try_count}, #{@attendance}) RETURNING *"
      @@fixtures << self
      @id = SqlRunner.run(sql).first['id'].to_i
    rescue
    end
    return @id
  end

  def delete
    begin
      @@fixtures ||= Fixture.retrieve_from_db
      sql = "DELETE FROM fixtures WHERE id = #{@id}"
      SqlRunner.run(sql)
      @@fixtures.delete(Fixture.find_by_id(@id))
      @id = nil
    rescue
      # PSQL will prevent this action if there are references to this entry
    end
  end

 def update
   @@fixtures ||= Fixture.retrieve_from_db
   sql = "UPDATE fixtures SET (home_team_id, away_team_id, ground_id, referee_id, round_no, home_score, away_score, home_try_count, away_try_count, attendance) = (#{@home_team.id}, #{@away_team.id}, #{@ground.id}, #{@referee.id}, #{@round_no}, #{@home_score}, #{@away_score}, #{@home_try_count}, #{@away_try_count}, #{@attendance}) WHERE id = #{@id}"
   SqlRunner.run(sql)
   master = Fixture.find_by_id(@id)
   # Update @@fixtures if self is not on the list
   if master != self
     # Working with a copy so don't trust any of the referenced instances
     master.home_team = Team.find_by_id(@home_team.id)
     master.away_team = Team.find_by_id(@away_team.id)
     master.ground = Ground.find_by_id(@ground.id)
     master.referee = Referee.find_by_id(@referee.id)
     master.round_no = @round_no
     master.home_score = @home_score
     master.away_score = @away_score
     master.home_try_count = @home_try_count
     master.away_try_count = @away_try_count
     master.attendance = @attendance
   end
 end

  def to_s
    result  = "%-10s#{@home_team} #{@home_score} v #{@away_score} #{@away_team} (attendance: #{@attendance} / #{(@attendance*100)/@ground.capacity}%%)\n" % ["Round #{@round_no}:"]
    result += " " * 10 + "Ground:  #{@ground}\n"
    result += " " * 10 + "Referee: #{@referee}\n"
  end
end