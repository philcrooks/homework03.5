require_relative ('../db/sql_runner')

class Country

  attr_reader :id, :name

  private

  def Country.retrieve_from_db
    sql = "SELECT * FROM countries"
    result = SqlRunner.run(sql)
    return result.map { | options | Country.new(options) }
  end

  public

  def Country.delete_all
    begin
      sql = "DELETE FROM countries"
      SqlRunner.run(sql)
      @@countries = []
    rescue
    end
  end

  def Country.all
    @@country ||= Country.retrieve_from_db
    return @@countries
  end

  def Country.find_by_id(id)
    @@countries ||= Country.retrieve_from_db
    return @@countries.find { | country | country.id == id }
  end

  def initialize (options)
    @id = options['id'].to_i
    @name = options['name']
  end

  def save
    # This save has no table interdependencies so should succeed
    @@countries ||= Country.retrieve_from_db
    sql = "INSERT INTO countries (name) VALUES ('#{@name}') RETURNING *"
    @id = SqlRunner.run(sql).first['id'].to_i
    @@countries << self
    return @id
  end

  def delete
    begin
      @@countries ||= retrieve_from_db
      sql = "DELETE FROM countries WHERE id = #{@id}"
      SqlRunner.run(sql)
      @id = nil
      @@countries.delete(self)
    rescue
      # PSQL will prevent this action if there are references to this entry
    end
  end

  def to_s
    return "#{@name}"
  end
end