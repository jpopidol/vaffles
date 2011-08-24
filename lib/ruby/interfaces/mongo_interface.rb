#General structure of the db interface if another db is chosen in the future

require "rubygems"
require "mongo"

require FILE_PATH + "/lib/ruby/node/node.rb"

module MongoInterface

  def connect(name, host, port)
    @name = name || "wafflemanagementdb"
    @host = host || "localhost"
    @port = port || 27017
  
    @db = Mongo::Connection.new(@host, @port).db(@name)
  end

  def create_table(table_name)
    collection = @db[table_name]
    collection
  end
  
  def create_index(table_name, field, unique)
    @db[table_name].create_index(field, :unique => unique) 
  end
  
  def test_output(table_name)
    table = @db[table_name]
    puts table.count
    entries = table.find()
    entries.each do |entry|
      puts entry.inspect
    end
  end

  def insert(table_name, entry)
    table = @db[table_name]
    table.insert(entry)
  end
  
  def delete(table_name, entry)
  end
  
  def drop(table_name)
    @db[table_name].drop
  end

  def find(table_name, field_hash)
    query = @db[table_name].find(field_hash)
    query
  end

  def update(table_name, field_hash, entry)
    table = @db[table_name].update(field_hash,entry)
  end

end
