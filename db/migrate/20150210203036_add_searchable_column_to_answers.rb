class AddSearchableColumnToAnswers < ActiveRecord::Migration
  def up
    add_column :answers, :searchable, :tsvector

    update_statement = <<-SQL
      UPDATE answers
      SET searchable =
        to_tsvector('english', body)
    SQL

    index_statement = <<-SQL
      CREATE INDEX index_answers_on_searchable ON answers
      USING gin(searchable)
    SQL

    trigger_statement = <<-SQL
      CREATE TRIGGER answers_searchable_update BEFORE INSERT OR UPDATE
      ON answers FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(searchable, 'pg_catalog.english', body)
    SQL

    ActiveRecord::Base.connection.execute(update_statement)
    ActiveRecord::Base.connection.execute(index_statement)
    ActiveRecord::Base.connection.execute(trigger_statement)
  end

  def down
    ActiveRecord::Base.connection.
      execute("DROP TRIGGER answers_searchable_update ON answers")
    ActiveRecord::Base.connection.
      execute("DROP INDEX index_answers_on_searchable")

    remove_column :answers, :searchable
  end
end
