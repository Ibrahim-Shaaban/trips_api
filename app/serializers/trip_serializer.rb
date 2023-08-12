class TripSerializer
  include JSONAPI::Serializer
  attributes :status, :name

  belongs_to :driver
  has_many :locations
end
