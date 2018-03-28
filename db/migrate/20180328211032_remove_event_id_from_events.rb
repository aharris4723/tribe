class RemoveEventIdFromEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :event_id, :integer
  end
end
