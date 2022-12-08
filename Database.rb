require "sqlite3"
require "singleton"

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("database.db")
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Question
  attr_accessor :id, :title, :body, :author_id

  def initialize(options => {})
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @author_id = options["author_id"]
  end

  def self.find_by_id(num)
    data = QuestionsDatabase.instance.execute(<<-SQL, num)
    SELECT
      *
    FROM
      questions
    WHERE
      id = ?
    SQL
    return nil if data.length == 0
    User.new(data.first)
  end

  def find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      author_id = ?
    SQL
  end

  def author
    User.find_by_id(author_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end


end

class User
  attr_accessor :id, :fname, :lname

  def self.find_by_id(num)
    data = QuestionsDatabase.instance.execute(<<-SQL, num)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL
    return nil if data.length == 0
    User.new(data.first)
  end

  # def self.find_by_name(input)
  #   data = QuestionsDatabase.instance.execute("SELECT * FROM users WHERE users.fname = input")
  #   User.new(data)
  #  end

  def initialize(options => {})
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? AND
      lname = ?
    SQL
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end
end

class QuestionFollow
  attr_accessor :id, :user_id, :question_id

  def initialize(options => {})
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end

  def self.find_by_id(num)
    data = QuestionsDatabase.instance.execute(<<-SQL, num)
    SELECT
    *
    FROM
    question_follows
    WHERE
    id = ?
    SQL
    return nil if data.length == 0
    User.new(data.first)
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      users
    JOIN
      questions ON questions.author_id = user(id)
    WHERE
      question_id = ?
    SQL

    return nil if data.length == 0
    User.new(data)
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      questions
    JOIN
      users ON users.id = 
    WHERE
      user_id = ?
    SQL
    

end

class Reply
  attr_accessor :id, :body, :question_id, :parent_id, :replier_id

  def initialize(options)
    @id = options["id"]
    @body = options["body"]
    @question_id = options["question_id"]
    @parent_id = options["parent_id"]
    @replier_id = option["replier_id"]
  end

  def self.find_by_id(num)
    data = QuestionsDatabase.instance.execute(<<-SQL, num)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
    SQL
    return nil if data.length == 0
    User.new(data.first)
  end

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
    SQL
  end

  def self.find_by_question(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
  end

  def author
    Question.find_by_id() #*********
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    User.find_by_id(parent_id)
  end

  def child_replies
    User.find_by_id(replier_id)
  end
end

class QuestionLike
  attr_accessor :id, :likes, :question_id, :user_id

  def initialize(options)
    @id = options["id"]
    @likes = options["likes"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end

  def self.find_by_id(num)
    data = QuestionsDatabase.instance.execute(<<-SQL, num)
    SELECT
    *
    FROM
    question_likes
    WHERE
    id = ?
    SQL
    return nil if data.length == 0
    User.new(data.first)
  end
end
