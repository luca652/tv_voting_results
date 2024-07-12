class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :campaign, null: false, foreign_key: true
      t.string :validity
      t.string :choice

      t.timestamps
    end
  end
end
