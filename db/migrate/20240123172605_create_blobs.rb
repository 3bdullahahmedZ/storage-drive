class CreateBlobs < ActiveRecord::Migration[7.1]
  def change
    create_table :blobs do |t|
      t.string :name, index: { unique: true, name: 'unique_names' }
      t.integer :storage_type
      t.json :meta_data, null: false

      t.timestamps
    end
  end
end
