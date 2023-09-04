class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.integer :mentioned_report_id, null: false
      t.integer :mentioning_report_id, null: false

      t.timestamps
    end
  end
end
