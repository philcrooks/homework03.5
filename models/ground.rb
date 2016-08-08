require_relative ('../db/sql_runner')

class Ground

  attr_reader :id
  attr_accessor :name, :city, :capacity, :country

  private

  def Ground.retrieve_from_db
    sql = "SELECT * FROM grounds"
    result = SqlRunner.run(sql)
    return result.map { | options | Ground.new(options) }
  end

  public

  def Ground.delete_all
    begin
      sql = "DELETE FROM grounds"
      SqlRunner.run(sql)
      @@grounds = []
    rescue
    end
  end

  def Ground.all
    @@grounds ||= Ground.retrieve_from_db
    return @@grounds
  end

  def Ground.find_by_id(id)
    @@grounds ||= Ground.retrieve_from_db
    return @@grounds.find { | ground | ground.id == id }
  end

  def initialize (options)
    # @options = options
    @id = options['id'].to_i
    @name = options['name']
    @city = options['city']
    @capacity = options['capacity'].to_i
    # Note that @country will be nil if the countries table has not been populated.
    # PSQL will ensure the grounds table is not created until countries exists
    @country = Country.find_by_id(options['country_id'].to_i)
  end

  def save()
    begin
      @@grounds ||= Ground.retrieve_from_db
      sql = "INSERT INTO grounds (name, city, country_id, capacity) VALUES ('#{@name}', '#{@city}', #{@country.id}, #{@capacity}) RETURNING *"
      @id = SqlRunner.run(sql).first['id'].to_i
      @@grounds << self
    rescue
      puts "Ground.save failed on object %x" % [object_id * 2]
    end
    return @id
  end

  def delete
    begin
      @@grounds ||= Ground.retrieve_from_db
      sql = "DELETE FROM grounds WHERE id = #{@id}"
      SqlRunner.run(sql)
      @@grounds.delete(Ground.find_by_id(@id))
      @id = nil
    rescue
      # PSQL will prevent this action if there are references to this entry
      puts "Ground.delete failed on object %x" % [object_id * 2]

    end
  end

  def update
    begin
      @@grounds ||= Ground.retrieve_from_db
      sql = "UPDATE grounds SET (name, city, country_id, capacity) = ('#{@name}', '#{@city}', #{@country.id}, #{capacity}) WHERE id = #{@id}"
      SqlRunner.run(sql)
      master = Country.find_by_id(@id)
      # Update @@grounds if self is not on the list
      if master != self
        master.name = @name
        master.city = @city
        master.country = Country.find_by_id(@country.id)
        master.capacity = @capacity
      end
    rescue
      puts "Ground.update failed on object %x" % [object_id * 2]
    end
  end

  def to_s
    return "#{@name}, #{@city} (capacity #{@capacity})"
  end
end