class Trip < ApplicationRecord
  enum status: { ongoing: 0, completed: 1 }, _default: :ongoing

  validates :name, presence: true
  
  belongs_to :driver


  def self.create_new_one(current_driver, name)
    Trip.new(
      name: name,
      driver_id: current_driver.id
    )
  end
end
