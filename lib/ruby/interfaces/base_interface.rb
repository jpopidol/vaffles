#General structure of the db interface if another db is chosen in the future

module BaseInterface

  def connect(host, port)
    @name = "wafflemanagementdb"
    @host = host || "localhost"
    @port = port || 27017
  end
  
  def create
  end

  def insert(collection, entry)
  end
  
  def delete(collection, entry)
  end
  
  def drop(collection)
  end

end
