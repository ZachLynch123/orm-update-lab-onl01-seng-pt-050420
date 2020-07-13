require_relative "../config/environment.rb"

class Student
  
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
    id INTEGER PRIMARY KEY, 
    name TEXT, 
    grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end
  
  
  def save 
    if self.id 
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade,id)
      VALUES (?,?,?)
      SQL
      
      DB[:conn].execute(sql, self.name, self.grade, self.id)
   end
      
  end
  
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save 
    student
  end
  
  
  def self.drop_table
    
  end
  
  def self.new_from_db(row)
    new_student = self.new(row[1], row[2], row[0])

    new_student
  end
  
  def update 
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE name = ? 
      LIMIT 1 
    SQL
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
      row[1]
    end
  end

end
