class AddContentToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :content, :string
  end
end
