class FishesTable
  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create(name, url, user_id)
    insert_fish_sql = <<-SQL
      INSERT INTO fish (name, url, user_id)
      VALUES ('#{name}', '#{url}', '#{user_id}')
    SQL

    @database_connection.sql(insert_fish_sql)
  end

  # def find(user_id)
  #   find_sql = <<-SQL
  #     SELECT * FROM fish
  #     WHERE id = #{user_id}
  #   SQL
  #
  #   @database_connection.sql(find_sql).first
  # end
  #
  # def find_user(name)
  #   find_sql = <<-SQL
  #     SELECT id FROM fish
  #     WHERE name = '#{name}'
  #   SQL
  #
  #   @database_connection.sql(find_sql)
  # end

  def fishes
    fish_sql = <<-SQL
      SELECT * FROM fish
    SQL

    @database_connection.sql(fish_sql)
  end

  def find_by(username)
    find_by_sql = <<-SQL
      SELECT * FROM fish
      INNER JOIN users on fish.user_id = users.id
      WHERE users.username = '#{username}'
    SQL

    @database_connection.sql(find_by_sql)
  end
  #
  # def delete_user(name)
  #   delete_user_sql = <<-SQL
  #     DELETE FROM fish
  #     WHERE name = '#{name}'
  #   SQL
  #
  #   @database_connection.sql(delete_user_sql)
  # end

end