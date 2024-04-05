class AddPersonAttributesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :typeKey, :string
    add_column :users, :stateKey, :string
    add_column :users, :name, :string
    add_column :users, :descr, :jsonb
    add_column :users, :pictureDocumentId, :string
    add_column :users, :meta, :jsonb
    add_column :users, :person_email, :string
  end
end
