class AddContentToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :content, :string
  end
end
