require_relative ('../db/sql_runner')

class Country

  attr_reader :id
  attr_accessor :name

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
    @@countries ||= Country.retrieve_from_db
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
    # Could be adding a duplicate but will be given a new id
    @@countries ||= Country.retrieve_from_db
    sql = "INSERT INTO countries (name) VALUES ('#{@name}') RETURNING *"
    @id = SqlRunner.run(sql).first['id'].to_i
    @@countries << self
    return @id
  end

  def delete
    begin
      @@countries ||= retrieve_from_db
      # PSQL will prevent this action if there are references to this entry
      sql = "DELETE FROM countries WHERE id = #{@id}"
      SqlRunner.run(sql)
      # May be deleting using a copy - use the id to find the original
      @@countries.delete(Country.find_by_id(@id))
      @id = nil
    rescue
      puts "Country.delete failed on object %x" % [object_id * 2]
    end
  end

  def update
    begin
      @@countries ||= Country.retrieve_from_db
      # This will fail of the object has been deleted from the database
      sql = "UPDATE countries SET (name) = ('#{@name}') WHERE id = #{@id}"
      SqlRunner.run(sql)
      master = Country.find_by_id(@id)
      # Update @@countries if self is not on the list
      master.name = @name if master != self
    rescue
      puts "Country.update failed on object %x" % [object_id * 2]
    end
  end

  def to_s
    return "#{@name}"
  end
end