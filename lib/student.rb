class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save #put instance data into table
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade) #put instance data into table

    sql = <<-SQL
      SELECT students.id
      FROM students
      ORDER BY id DESC
      LIMIT 1
    SQL
    @id = (DB[:conn].execute(sql))[0][0] #get id from table and assign to instance

    self
  end

  def self.create(hash)
    new_student = Student.new(hash[:name], hash[:grade])
    new_student.save
  end

end
