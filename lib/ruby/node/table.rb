require FILE_PATH + "/lib/ruby/node/node_fields.rb"
require FILE_PATH + "/lib/ruby/node/node_status.rb"
require FILE_PATH + "/lib/ruby/database.rb"

class NodeTable
  NODE_LIST_YAML_PATH = FILE_PATH + "/etc/node_list.yml"

  include Node::Fields
  include Node::Status
  include Database

  def initialize(master_hostname)
    @master_hostname = master_hostname
  end

  def import_list(file_path)
    list = YAML::load(File.open(file_path))
    list["nodes"].each do |node|
      entry = create_node_entry(
        @master_hostname,
        node,
        "fake entry")
      puts entry.inspect
      @db[TABLE_NAME].insert(entry)
    end
  end

  def create_node_entry(master_hostname, slave_hostname, notes)
    entry = { 
      SLAVE_HOSTNAME  => slave_hostname,
      NOTES           => notes,
      STATUS          => NEW,
      MASTER_HOSTNAME => master_hostname
    }   
    entry
  end

  def create_table
    @db[TABLE_NAME].create_index(
      SLAVE_HOSTNAME, 
      :unique => true)
  end

  #Creating and deleting a node table is an all or nothing, status of individual nodes is managed elsewhere
  def construct
    create_table
    import_list(NODE_LIST_YAML_PATH)
  end

  def purge
    @db[TABLE_NAME].drop
  end

  def reconstruct
    purge
    construct
  end

  def output
    entries = @db[TABLE_NAME].find()
    entries.each do |entry|
      puts entry.inspect
    end
  end

  def get_node_by_hostname(hostname)
    
  end

  def setup(node_id)
  end
  
  def teardown
  end 

end
