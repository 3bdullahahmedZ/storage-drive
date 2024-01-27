class CreateStoredFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :stored_files do |t|
      t.text :file

      t.timestamps
    end
  end
end
