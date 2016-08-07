require('pg')

class SqlRunner

  def SqlRunner.requests
    @@requests ||= []
    return @@requests
  end

  def self.run( sql )
    @@requests ||= []
    @@requests << sql
    db = PG.connect({ dbname: 'league', host: 'localhost' })
    result = db.exec( sql )
    db.close
    return result
  end

end