require FILE_PATH + "/lib/ruby/node/node.rb"
require FILE_PATH + "/lib/ruby/database.rb"

class NodeTable
  NODE_LIST_YAML_PATH = FILE_PATH + "/etc/node_list.yml"

  def initialize(db, master_hostname)
    @db = db
    @master_hostname = master_hostname
  end

  def load_list(file_path)
    list = YAML::load(File.open(file_path))
    list["nodes"].each do |node|
      entry = create_node_entry(
        @master_hostname,
        node,
        "fake entry")
      puts entry.inspect
      @db.insert(Node::Fields::TABLE_NAME, entry)
    end
  end

  def create_node_entry(master_hostname, slave_hostname, notes)
    entry = { 
      Node::Fields::SLAVE_HOSTNAME  => slave_hostname,
      Node::Fields::NOTES           => notes,
      Node::Fields::STATUS          => Node::Status::NEW,
      Node::Fields::MASTER_HOSTNAME => master_hostname
    }   
    entry
  end

  def create_table
    @db.create_table(Node::Fields::TABLE_NAME)
    @db.create_index(
      Node::Fields::TABLE_NAME,
      Node::Fields::SLAVE_HOSTNAME, 
      true)
  end

  #Creating and deleting a node table is an all or nothing, status of individual nodes is managed elsewhere
  def construct
    create_table
    load_list(NODE_LIST_YAML_PATH)
  end

  def purge
    @db.drop(Node::Fields::TABLE_NAME)
  end

  def reconstruct
    purge
    construct
  end

  def output
    @db.test_output(Node::Fields::TABLE_NAME)
  end

  def get_node_by_hostname(hostname)
    
  end

  def setup(node_id)
  end
  
  def teardown
  end 

end
