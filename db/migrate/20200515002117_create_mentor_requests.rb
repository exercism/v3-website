class CreateMentorRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :mentor_requests do |t|
      t.string :uuid, null: false

      t.belongs_to :solution, foreign_key: true, null: false

      t.integer :status, null: false, limit: 1, default: 0

      t.text :comment_markdown, null: false
      t.text :comment_html, null: false

      t.belongs_to :locked_by, foreign_key: { to_table: :users }, null: true
      t.datetime :locked_until, null: true

      t.timestamps
    end
  end
end