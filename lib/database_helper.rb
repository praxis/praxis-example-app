class DatabaseHelper

  def self.setup!(connection)
    DB.create_table! :users do
      primary_key :id

      Integer :primary_blog_id

      String :first
      String :last

      String :timestamps
    end

    DB.create_table! :posts do
      primary_key :id

      Integer :author_id
      Integer :blog_id

      String :title
      String :content
      String :url

      String :timestamps
    end

    DB.create_table! :blogs do
      primary_key :id

      Integer :owner_id

      String :name
      String :description
      String :url

      String :timestamps
      String :tags
    end
  end


end
