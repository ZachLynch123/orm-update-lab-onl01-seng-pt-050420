require "spec_helper"

describe "Student" do

  let(:josh) {Student.new("Josh", "9th")}

  before(:each) do |example|
    unless example.metadata[:skip_before]

      DB[:conn].execute("DROP TABLE IF EXISTS students")
      sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL
      DB[:conn].execute(sql)
    end
  end

  describe "attributes" do
    it 'has a name and a grade' do
      student = Student.new("Tiffany", "11th")
      expect(student.name).to eq("Tiffany")
      expect(student.grade).to eq("11th")
    end

    it 'has an id that defaults to `nil` on initialization' do
      expect(josh.id).to eq(nil)
    end
  end

  describe ".create_table" do
    it 'creates the students table in the database', :skip_before do
      DB[:conn].execute("DROP TABLE IF EXISTS students")
      Student.create_table
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(['students'])
    end
  end

  describe ".drop_table" do
    it 'drops the students table from the database' do
      Student.drop_table
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(nil)
    end
  end



  describe ".create" do
    it 'creates a student with two attributes, name and grade, and saves it into the students table.' do
      Student.create("Sally", "10th")
      expect(DB[:conn].execute("SELECT * FROM students")).to eq([[1, "Sally", "10th"]])
    end
  end

  describe '.new_from_db' do
    it 'creates an instance with corresponding attribute values' do
      row = [1, "Pat", 12]
      pat = Student.new_from_db(row)

      expect(pat.id).to eq(row[0])
      expect(pat.name).to eq(row[1])
      expect(pat.grade).to eq(row[2])
    end
  end


end
