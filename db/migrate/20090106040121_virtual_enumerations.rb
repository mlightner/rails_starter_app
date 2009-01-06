class VirtualEnumerations < ActiveRecord::Migration
  def self.up
    create_table "enumerations", :force => true do |t|
      t.string  "type"
      t.string  "name"
      t.string  "description"
      t.integer "position"
      t.boolean "active"
    end

    add_index "enumerations", ["type"], :name => "enumerations_type_index"
  end

  def self.down
    drop_table "enumerations"
  end
end
