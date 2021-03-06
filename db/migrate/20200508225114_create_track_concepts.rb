class CreateTrackConcepts < ActiveRecord::Migration[6.0]
  def change
    create_table :track_concepts do |t|
      t.belongs_to :track, foreign_key: true, null: false

      t.string :slug, null: false
      t.string :uuid, null: false, index: { unique: true }

      t.string :name, null: false

      # TODO: Make null: false before launch (Check ETL won't break)
      t.string :blurb, null: true, limit: 350
      t.string :synced_to_git_sha, null: false

      t.timestamps
    end
  end
end
