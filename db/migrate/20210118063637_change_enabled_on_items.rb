class ChangeEnabledOnItems < ActiveRecord::Migration[5.2]
  def change
    change_column_default :items, :enabled, from: true, to: false
  end
end
