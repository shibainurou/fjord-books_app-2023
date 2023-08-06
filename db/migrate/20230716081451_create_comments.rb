class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.integer :created_user_id
      t.string :content
      t.references :commentable, polymorphic: true

      t.timestamps
    end
  end
end
