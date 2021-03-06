module V2ETL
  module TableMigrations
    class TableMigration
      def add_column(*args)
        connection.add_column table_name, *args
      end

      def add_index(*args)
        connection.add_index table_name, *args
      end

      def remove_column(*args)
        connection.remove_column table_name, *args
      end

      def rename_column(*args)
        connection.rename_column table_name, *args
      end

      def change_column_null(*args)
        connection.change_column_null table_name, *args
      end

      def add_foreign_key(*args)
        connection.add_foreign_key table_name, *args
      end

      def add_non_nullable_column(name, type, default = nil, args = {})
        add_column name, type, args.merge(null: true)
        if block_given?
          transaction do
            model.find_each do |record|
              record.update!(yield)
            end
          end
        else
          model.update_all("#{name} = #{default}")
        end
        change_column_null name, false
      end

      delegate :transaction, to: :connection
      def connection
        ActiveRecord::Base.connection
      end
    end
  end
end
