class CreateTracks < ActiveRecord::Migration[6.0]
  def change
    # TODO: Add median_wait_time
    # TODO: syntax_highlighter_language ?
    create_table :tracks do |t|
      t.string :slug, null: false, index: { unique: true }
      t.string :title, null: false
      t.string :blurb, null: false, limit: 400

      t.string :repo_url, null: false

      t.string :synced_to_git_sha, null: false

      t.integer :num_exercises, limit: 3, null: false, default: 0
      t.integer :num_concepts, limit: 3, null: false, default: 0

      t.json :tags, null: true

      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
