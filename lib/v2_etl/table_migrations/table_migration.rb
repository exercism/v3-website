module V2ETL
  module TableMigrations
    class TableMigration
      %i[
        rename_table
        add_column remove_column rename_column change_column_null
        add_foreign_key remove_foreign_key
        add_index remove_index
      ].each do |meth|
        define_method(meth) do |*args|
          connection.send(meth, table_name, *args)
        end
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
