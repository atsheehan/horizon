class AddSearchableToQuestions < ActiveRecord::Migration
  def up
    add_column :questions, :searchable, :tsvector

    update_statement = <<-SQL
      UPDATE questions
      SET searchable =
        to_tsvector('english', title || ' ' || body)
    SQL

    index_statement = <<-SQL
      CREATE INDEX index_questions_on_searchable ON questions
      USING gin(searchable)
    SQL

    trigger_statement = <<-SQL
      CREATE TRIGGER questions_searchable_update BEFORE INSERT OR UPDATE
      ON questions FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(searchable, 'pg_catalog.english', title, body)
    SQL

    ActiveRecord::Base.connection.execute(update_statement)
    ActiveRecord::Base.connection.execute(index_statement)
    ActiveRecord::Base.connection.execute(trigger_statement)
  end

  def down
    ActiveRecord::Base.connection.
      execute("DROP TRIGGER questions_searchable_update ON questions")
    ActiveRecord::Base.connection.
      execute("DROP INDEX index_questions_on_searchable")

    remove_column :questions, :searchable
  end
end
