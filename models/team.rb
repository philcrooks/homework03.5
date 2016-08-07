require_relative ('../db/sql_runner')
require_relative ('country')

class Team

  attr_reader :id, :name, :city, :country

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
      @@teams ||= Team.retrieve_from_db
      sql = "INSERT INTO teams (name, city, country_id) VALUES ('#{@name}', '#{@city}', #{@country.id}) RETURNING *"
      @id = SqlRunner.run(sql).first['id'].to_i
      @@teams << self
    rescue
    end
    return @id
  end

  def delete
    begin
      @@teams ||= Team.retrieve_from_db
      sql = "DELETE FROM teams WHERE id = #{@id}"
      SqlRunner.run(sql)
      @id = nil
      @@teams.delete(self)
    rescue
      # PSQL will prevent this action if there are references to this entry
    end
  end

  def to_s
    return "#{@name}"
  end
end