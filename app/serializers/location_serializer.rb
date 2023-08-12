class LocationSerializer
  include JSONAPI::Serializer
  attributes :longitude, :latitude

  belongs_to :trips
end
