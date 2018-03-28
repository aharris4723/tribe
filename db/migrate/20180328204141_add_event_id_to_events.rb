class AddEventIdToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :event_id, :integer
  end
end
