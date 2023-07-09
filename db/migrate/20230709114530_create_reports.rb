class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.integer :created_user_id
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
