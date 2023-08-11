class DriverSerializer
  include JSONAPI::Serializer
  attributes :name, :email

  has_many :trips
end
