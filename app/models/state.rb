# State Model
class State < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  validates :name, presence: :true,uniqueness: true
   has_one :asignation
   has_one :notification
   belongs_to :updateasignation
   before_save :capitalize_state
   def capitalize_state
    self.name.capitalize!
   end
  # Fields for the search form in the navbar
  def self.search_field
    :name_cont
  end
end
