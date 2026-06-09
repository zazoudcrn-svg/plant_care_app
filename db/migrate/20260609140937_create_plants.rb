class CreatePlants < ActiveRecord::Migration[8.1]
  def change
    create_table :plants do |t|
      t.string :name
      t.string :specie
      t.string :plant_location
      t.date :date_added
      t.date :last_watered_on
      t.date :last_fertilized_on
      t.text :system_prompt
      t.string :sunlight_exposure
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
