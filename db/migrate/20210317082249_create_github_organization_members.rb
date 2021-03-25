class CreateGithubOrganizationMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :github_organization_members do |t|
      t.string :username, null: false, index: { unique: true }
      t.boolean :alumnus, default: false, null: false

      t.timestamps
    end
  end
end
