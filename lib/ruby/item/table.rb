require FILE_PATH + "/lib/ruby/database/database.rb"
require FILE_PATH + "/lib/ruby/test_list/fields.rb"
require FILE_PATH + "/lib/ruby/test_list/status.rb"

class TestTable
  TEST_LIST_YAML_PATH = FILE_PATH + "/etc/mock_test_list.yml"

  include TestTable
  include Database
  

  def initialize(db)
    @db = db
  end

  def load_list(file_path)
    list = YAML::load(File.open(file_path))
    list["tests"].each do |test|
      entry = create_test_entry(test)
      puts entry.inspect
      @db[Fields::TABLE_NAME].insert(entry)
    end
  end

  def create_test_entry(test_name)
    entry = {
      Fields::TEST_NAME  => test_name,
      Fields::STATUS     => Status::NEW
    }   
    entry
  end

  def create_table
  end

  #Creating and deleting a node table is an all or nothing, status of individual nodes is managed elsewhere
  def construct
    create_table
    load_list(TEST_LIST_YAML_PATH)
  end

  def purge
    @db[Fields::TABLE_NAME].drop
  end

  def reconstruct
    purge
    construct
  end

  def output
    entries = @db[Fields::TABLE_NAME].find()
    entries.each do |entry|
      puts entry.inspect
    end
  end

  def get_new_tests
    new_tests = @db[Fields::TABLE_NAME].find(
      {Fields::STATUS => Status::NEW})
    i = 0
    new_tests.each do |test|
      if i<5
        test["status"] = Status::IN_PROGRESS
        @db[Fields::TABLE_NAME].update(
          {"_id" => test["_id"]},
          test)
        i += 1
      end
      puts test.inspect
    end
  end

  def setup(node_id)
  end
  
  def teardown
  end 

end
