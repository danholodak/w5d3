require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton
    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
      end

end

class User
    attr_accessor :id, :fname, :lname
    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map { |datum| User.new(datum) }
    end

    def initialize(input_hash)
        @id = input_hash['id']
        @fname = input_hash['fname']
        @lname = input_hash['lname']
    end

    def self.find_by_id(num)
        data = QuestionsDatabase.instance.execute(<<-SQL, num)
            SELECT * 
            FROM users
            WHERE id = ?
        SQL
        User.new(data[0])
    end

    def self.find_by_name(fname, lname)
        data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT * 
            FROM users
            WHERE fname = ?
            AND lname = ?
        SQL
        User.new(data[0])
    end

    def authored_questions
        Question.find_by_author(self.id)
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(self.id)
    end


end

class Question
    attr_accessor :id, :title, :body, :author_id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map { |datum| Question.new(datum) }
    end

    def initialize(input_hash)
        @id = input_hash['id']
        @title = input_hash['title']
        @body = input_hash['body']
        @author_id = input_hash['author_id']
    end

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM questions
            WHERE id = ?
        SQL
        Question.new(data[0])
    end

    def self.find_by_author(author_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM questions
            WHERE author_id = ?
        SQL
        data.map{|datum| Question.new(datum)}
    end

    def author  
        User.find_by_id(self.author_id)
    end

    def replies
        Reply.find_by_question_id(self.id)
    end

    def followers
        QuestionFollow.followers_for_question_id(self.id)
    end

end

class QuestionFollow
    attr_accessor :id, :follower_id, :question_id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
        data.map { |datum| QuestionFollow.new(datum) }
    end

    def initialize(input_hash)
        @id = input_hash['id']
        @follower_id = input_hash['follower_id']
        @question_id = input_hash['question_id']
    end

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM question_follows
            WHERE id = ?
        SQL
        QuestionFollow.new(data[0])
    end

    def self.followers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT 
                *
            FROM
                users
            WHERE id IN (
                    SELECT  user_id
                    FROM questions
                    WHERE id = ?)
        SQL
        data.map { |datum| User.new(datum) }
    end

    def self.followed_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT *
            FROM questions
            WHERE id in (
                SELECT question_id
                FROM question_follows
                WHERE user_id = ?
            )
        SQL
        data.map { |datum| Question.new(datum) }
    end


end

class Reply
    attr_accessor :id, :question_id, :parent_reply, :author_id, :body

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        data.map { |datum| Reply.new(datum) }
    end

    def initialize(input_hash)
        @id = input_hash['id']
        @question_id = input_hash['question_id']
        @parent_reply = input_hash['parent_reply'] || @parent_reply = "none"
        @author_id = input_hash['author_id']
        @body = input_hash['body']

    end

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM replies
            WHERE id = ?
        SQL
        Reply.new(data[0])
    end

    def self.find_by_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT * 
            FROM replies
            WHERE user_id = ?
        SQL
        data.map{|datum| Reply.new(datum)}
    end

    def self.find_by_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT * 
            FROM replies
            WHERE question_id = ?
        SQL
        data.map{|datum| Reply.new(datum)}
    end

    def author
        User.find_by_id(self.author_id)
    end

    def question
        Question.find_by_id(self.question_id)
    end

    def parent_replies
        return nil if self.parent_reply == "none"
        Reply.find_by_id(self.parent_reply)
    end

    def child_replies
        data = QuestionsDatabase.instance.execute(<<-SQL, self.id)
        SELECT * 
        FROM replies
        WHERE parent_reply = ?
    SQL
    data.map{|datum| Reply.new(datum)}
    end


end

class QuestionLike
    attr_accessor :id, :question_id, :user_id

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
        data.map{ |datum| QuestionLike.new(datum)}
    end

    def initialize(input_hash)
        @id = input_hash['id']
        @question_id = input_hash['question_id']
        @user_id = input_hash['user_id']
    end

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM question_likes
            WHERE id = ?
        SQL
        QuestionLike.new(data[0])
    end

end

