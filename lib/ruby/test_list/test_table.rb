require FILE_PATH + "/lib/ruby/database.rb"
require FILE_PATH + "/lib/ruby/test_list/test.rb"

class TestTable
  TEST_LIST_YAML_PATH = FILE_PATH + "/etc/mock_test_list.yml"

  def initialize(db)
    @db = db
  end

  def load_list(file_path)
    list = YAML::load(File.open(file_path))
    list["tests"].each do |test|
      entry = create_test_entry(test)
      puts entry.inspect
      @db.insert(TestTable::Fields::TABLE_NAME, entry)
    end
  end

  def create_test_entry(test_name)
    entry = {
      TestTable::Fields::TEST_NAME  => test_name,
      TestTable::Fields::STATUS     => TestTable::Status::NEW
    }   
    entry
  end

  def create_table
    @db.create_table(TestTable::Fields::TABLE_NAME)
  end

  #Creating and deleting a node table is an all or nothing, status of individual nodes is managed elsewhere
  def construct
    create_table
    load_list(TEST_LIST_YAML_PATH)
  end

  def purge
    @db.drop(TestTable::Fields::TABLE_NAME)
  end

  def reconstruct
    purge
    construct
  end

  def output
    @db.test_output(TestTable::Fields::TABLE_NAME)
  end

  def get_new_tests
    new_tests = @db.find(
      TestTable::Fields::TABLE_NAME, 
      {TestTable::Fields::STATUS => TestTable::Status::NEW})
    i = 0
    new_tests.each do |test|
      if i<5
        test["status"] = TestTable::Status::IN_PROGRESS
        @db.update(
          TestTable::Fields::TABLE_NAME,
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
