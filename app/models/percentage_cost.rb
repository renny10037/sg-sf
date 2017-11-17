# PercentageCost Model
class PercentageCost < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  belongs_to :order, class_name: "Planner::Order"
  has_many :asignations
  validate :percentage
  validates :order_id,:quantify, presence: :true

  def create=(value)
      @quantify = value
  end
  def update=(value)
      @quantify = value
  end

  def percentage
    if self.quantify != nil
    	if self.quantify <= 0 or self.quantify > 100
    		errors.add(:quantify, "el rango debe ser entre 1 y 100")
    	end
      unless (self.order.asignations == nil) or (self.order.asignations == [])
        if self.quantify <= @quantify
          errors.add(:quantify, "el Porcentaje no puede ser menor o igual que el porcentaje ya estalecido:#{@quantify}%")
        end
      end
    end
  end

 
 
  # Fields for the search form in the navbar
  def self.search_field
    :order_id_or_quantify_cont
  end
end
