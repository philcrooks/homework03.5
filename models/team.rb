require_relative ('../db/sql_runner')
require_relative ('country')

class Team

  attr_reader :id
  attr_accessor :name, :city, :country

  private

  def Team.retrieve_from_db
    sql = "SELECT * FROM teams"
    result = SqlRunner.run(sql)
    return result.map { | options | Team.new(options) }
  end

  public

  def Team.delete_all
    begin
      sql = "DELETE FROM teams"
      SqlRunner.run(sql)
      @@teams = []
    rescue
    end
  end

  def Team.find_by_id(id)
    @@teams ||= Team.retrieve_from_db
    return @@teams.find { | team | team.id == id }
  end

  def Team.all
    @@teams ||= Team.retrieve_from_db
    return @@teams
  end

  def initialize (options)
    @@teams ||= Team.retrieve_from_db
    # @options = options
    @id = options['id'].to_i
    @name = options['name']
    @city = options['city']
    # Note that @country will be nil if the countries table has not been populated.
    # PSQL will ensure the teams table is not created until countries exists
    @country = Country.find_by_id(options['country_id'].to_i)
  end

  def save ()
    begin
      # @@teams ||= Team.retrieve_from_db
      sql = "INSERT INTO teams (name, city, country_id) VALUES ('#{@name}', '#{@city}', #{@country.id}) RETURNING *"
      @id = SqlRunner.run(sql).first['id'].to_i
      @@teams << self
    rescue
      puts "Team.save failed on object %x" % [object_id * 2]
    end
    return @id
  end

  def delete
    begin
      # @@teams ||= Team.retrieve_from_db
      sql = "DELETE FROM teams WHERE id = #{@id}"
      SqlRunner.run(sql)
      @@teams.delete(Team.find_by_id(@id))
      @id = nil
    rescue
      # PSQL will prevent this action if there are references to this entry
      puts "Team.delete failed on object %x" % [object_id * 2]
    end
  end

  def update
    begin
      # @@teams ||= Team.retrieve_from_db
      sql = "UPDATE teams SET (name, city, country_id) = ('#{@name}', '#{@city}', #{@country.id}) WHERE id = #{@id}"
      SqlRunner.run(sql)
      master = Team.find_by_id(@id)
      # Update @@teams if self is not on the list
      if master != self
        master.name = @name
        master.city = @city
        master.country = Country.find_by_id(@country.id)
      end
    rescue
      puts "Team.update failed on object %x" % [object_id * 2]
    end
  end

  def to_s
    return "#{@name}"
  end
end