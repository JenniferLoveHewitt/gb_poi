# frozen_string_literal: true

class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'cube'
    enable_extension 'earthdistance'

    create_table :points do |t|
      t.float :lat, null: false
      t.float :lon, null: false
      t.string :description
    end

    add_index :points, %i[lat lon], unique: true
  end
end
