require_relative ('../db/sql_runner')

class Referee

  attr_reader :id, :name, :country

  private

  def Referee.retrieve_from_db
    sql = "SELECT * FROM referees"
    result = SqlRunner.run(sql)
    return result.map { | options | Referee.new(options) }
  end

  public

  def Referee.delete_all
    begin
      sql = "DELETE FROM referees"
      SqlRunner.run(sql)
      @@referees = []
    rescue
    end
  end

  def Referee.find_by_id(id)
    @@refs ||= Referee.retrieve_from_db
    return @@refs.find { | ref | ref.id == id }
  end

  def initialize (options)
    # @options = options
    @id = options['id'].to_i
    @name = options['name']
    # Note that @country will be nil if the countries table has not been populated.
    # PSQL will ensure the referees table is not created until countries exists
    @country = Country.find_by_id(options['country_id'].to_i)
  end

  def save ()
    begin
      @@referees ||= Referee.retrieve_from_db
      sql = "INSERT INTO referees (name, country_id) VALUES ('#{@name}', #{@country.id}) RETURNING *"
      @id = SqlRunner.run(sql).first['id'].to_i
      @@referees << self
    rescue
    end
    return @id
  end

  def delete
    begin
      @@referees ||= Referee.retrieve_from_db
      sql = "DELETE FROM referees WHERE id = #{@id}"
      SqlRunner.run(sql)
      @id = nil
      @@referees.delete(self)
    rescue
      # PSQL will prevent this action if there are references to this entry
    end
  end

  def to_s
    return "#{@name} (#{@country})"
  end
end