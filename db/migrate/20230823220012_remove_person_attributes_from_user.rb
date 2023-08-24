class RemovePersonAttributesFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :typeKey, :string
    remove_column :users, :stateKey, :string
    remove_column :users, :name, :string
    remove_column :users, :descr, :jsonb
    remove_column :users, :pictureDocumentId, :string
    remove_column :users, :meta, :jsonb
    remove_column :users, :person_email, :string
  end
end
