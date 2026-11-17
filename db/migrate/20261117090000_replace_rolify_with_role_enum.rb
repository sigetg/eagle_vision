# Replaces rolify's two tables with one integer column, users.role
# (0 = student, 1 = staff). Existing admins become staff.
class ReplaceRolifyWithRoleEnum < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :role, :integer, null: false, default: 0

    if table_exists?(:users_roles)
      execute <<~SQL
        UPDATE users SET role = 1
        WHERE id IN (
          SELECT users_roles.user_id FROM users_roles
          JOIN roles ON roles.id = users_roles.role_id
          WHERE roles.name = 'admin'
        )
      SQL
    end

    drop_table :users_roles, if_exists: true
    drop_table :roles, if_exists: true
  end

  def down
    create_table :roles do |t|
      t.string :name
      t.references :resource, polymorphic: true
      t.timestamps
    end
    create_table :users_roles, id: false do |t|
      t.references :user
      t.references :role
    end
    remove_column :users, :role
  end
end
