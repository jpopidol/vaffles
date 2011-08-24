require 'yaml'

require FILE_PATH + "/lib/ruby/database.rb"
require FILE_PATH + "/lib/ruby/node/node_table.rb"

class Waffle
  def initialize
    @hostname = %x[cat /etc/hostname]
  end
  
  def populate_node_list
    #Create the table if it doesn't exist
    db = Database.new
    db.connect(nil,nil,nil)

    node_table = NodeTable.new(db, @hostname)
    node_table.reconstruct

  end

  def setup
  end
  
  def run
    #Determine test list
  end

  def teardown
  end

  
end
