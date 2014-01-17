class Flight < ActiveRecord::Base
  include PgSearch
  require 'forecast_io'

  belongs_to :ship
  has_many :trips
  has_many :passengers, :through => :trips
  belongs_to :origin
  belongs_to :destination

  pg_search_scope :search_origin, against: [:origin_id], using: {tsearch: {dictionary: 'english'}}, associated_against: {origin: :id}
  pg_search_scope :search_destination, against: [:destination_id], using: {tsearch: {dictionary: 'english'}}, associated_against: {destination: :id}

  def self.search_origin(search)
    if search
      find(:all, :conditions => ['origin LIKE ?', "%#{search}%"])
    else
      find(:all)
    end  
  end

  def self.search_destination(search)
    if search
      find(:all, :conditions => ['destination LIKE ?', "%#{search}%"])
    else
      find(:all)
    end  
  end

  def self.search_results(o, d)
    # origin = Flight.search_origin(o)
    # destination = Flight.search_destination(d)
    origin = Flight.find_all_by_origin_id(o)
    destination = Flight.find_all_by_destination_id(d)
    flights = []

    if origin.length > 1 && destination.length > 1
      origin.each do |on|
        destination.each do |dn|
          if on == dn
            flights << on
          else
            # Nothing! You get nothing!
          end
        end
      end
    elsif origin.length == 1 && destination.length > 1
      destination.each do |dn|
        if on == dn
          flights << on
        else
          # Nothing! You get nothing!
        end    
      end   
    elsif origin.length == 1 && destination.length == 1
      flights << origin.first
    else
      #Nothing! You get Nothing1
    end

    flights
  end

  def coordinates
    coordinates = []
    coordinates << Origin.find(self.origin_id).lat
    coordinates << Origin.find(self.origin_id).long
    coordinates
  end
end