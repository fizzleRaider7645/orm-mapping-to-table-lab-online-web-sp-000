class Student
  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end
  
  def self.create_table
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade TEXT
        )
        SQL
    DB[:conn].execute(sql) 
  end
  
  def self.drop_table
     sql =  <<-SQL
      DROP TABLE students;
     SQL
     DB[:conn].execute(sql)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?);
      SQL
    DB[:conn].execute(sql, self.name, self.grade)
    last_insert = DB[:conn].execute("SELECT * FROM students ORDER BY id DESC LIMIT 1;").flatten
    @id = last_insert[0]
    
  end
  
  def self.create(name:, grade:)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end
  
end
