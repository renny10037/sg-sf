# Payment Model
class Payment < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  belongs_to :asignation
  belongs_to :user
  has_many :notifications
  validate :validar_monto
  validates :asignation_id,:description, presence: :true
  after_create :notification_create
  after_update :notification_update
  after_create :send_mail
  after_update :send_mail_update

   def send_mail
      PaymentMailer.new_payment(self).deliver_later
   end
   def send_mail_update
      PaymentMailer.edit_payment(self).deliver_later
   end

  def quantify_create=(value)
    @@quantify = value
    
  end

  def quantify_update=(value)
    @@quantify = value.quantify
   
  end
  
  
  def validar_monto 
    if (self.quantify == nil) or (self.quantify == 0)
      errors.add(:quantify, "can't be blank")
    elsif self.quantify < 0
      errors.add(:quantify, "No se permiten valores negativos")
    else
      
      a = self.asignation.payment
      c = self.quantify
    	b = self.asignation.payments.inject(self.quantify - @@quantify) {|i,p| p.quantify + i}
      total = (b-a)-c
      if total.negative?
        total = total * -1
      end
    	if a < b 
    		errors.add(:quantify, "el monto no puede ser superior a: #{total}")
        return false
    	end
    end
  end
  def notification_create
    Notification.create(user:self.asignation.user_id,asignation:self.asignation.id,state:self.asignation.state.name,payment:self.id,quantify_payment:self.quantify,description:"Created Payment")
  end
  def notification_update
    Notification.create(user:self.asignation.user_id,asignation:self.asignation.id,state:self.asignation.state.name,payment:self.id,quantify_payment:self.quantify,description:"Updated Payment")
  end
  # Fields for the search form in the navbar
  def self.search_field
    :asignation_id_or_quantify_or_description_or_user_id_cont
  end
end
