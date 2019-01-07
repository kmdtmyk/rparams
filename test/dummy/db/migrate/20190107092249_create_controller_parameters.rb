class CreateControllerParameters < ActiveRecord::Migration[5.2]
  def change
    create_table :controller_parameters do |t|
      t.references :parent, polymorphic: true, index: true
      t.string :scope
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
