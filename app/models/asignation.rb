# Asignation Model
class Asignation < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  belongs_to :order, class_name: "Planner::Order"
  belongs_to :phase, class_name: "Planner::Phase"
  belongs_to :task, class_name: "Planner::Task"
  belongs_to :user
  belongs_to :state
  belongs_to :percentage_cost
  has_many :history_asignations
#  has_many :notifications
  has_many :payments
  validates :order_id,:phase_id,:date_start,:date_end,:description, presence: :true
  validates :user_id, presence: :true, on: :create
  
  #personalizados 
  after_create :history,:notification_create
  after_update :history,:notification_update
  validate :validar_monto,:dates
# Fields for the search form in the navbar
  def edit=(value)
    @@before_payment = value.payment 
  end
  def create=(value)
    @@before_payment = value
  end

  def fecha
    self.date_start = (Date.parse (self.date_start.strftime("%d-%m-%Y")))
    self.date_end = (Date.parse (self.date_end.strftime("%d-%m-%Y")))
  end
 
  
  def validar_monto
    if self.order_id == ""
      errors.add(:order, "can't be blank")
    else
      if self.order.percentage_cost == nil
          errors.add(:order_id, "debe seleccionar un percentage_cost") 
      else
        if (self.phase_id == "") or (self.phase_id == nil)
          errors.add(:order_id, "debe seleccionar una actividad") 
        else
          if ((payment == nil) or (payment == 0)) and (self.user_id != "2")
            errors.add(:payment, "can't be blank")
          elsif (payment < 0)
            errors.add(:payment, "No se permiten valores negativos")
          elsif (self.user_id == "2")
            self.payment = 0
          else
            -pagado = self.payments.inject(0) {|i,p| p.quantify + i}
            if self.payment < pagado
              errors.add(:payment, "el monto no puede ser inferior al monto ya pagado:#{pagado}")
            end
            if self.order.payment_currency == "Bolivar"
              percentage = ((self.phase.task.cost_bolivar.to_f)*(self.order.percentage_cost.quantify.to_f))/(100)
              if self.payment > percentage
                errors.add(:payment, "el monto no puede ser superior a:#{percentage}Bs")
                self.payment = 0 
              end
            elsif self.order.payment_currency == "Dolar"
               percentage = ((self.phase.task.cost_dolar.to_f)*(self.order.percentage_cost.quantify.to_f))/(100)
              if self.payment > percentage
                errors.add(:payment, "el monto no puede ser superior a:#{percentage}$")
              end

            end
          end
        end
      end
    end
  end

  def dates
    if self.order_id == ""
      errors.add(:order, "debe seleccionar una orden") 
    else
      if (date_start == nil)
        errors.add(:date_start, "can't be blank")
      elsif (date_end == nil)
        errors.add(:date_end, "can't be blank")
      else
        if (Date.parse (self.date_start.strftime("%d-%m-%Y"))) > (Date.parse (self.date_end.strftime("%d-%m-%Y")))
          errors.add(:date_start,"estimado usuario la fecha inicial no puede ser mayor a la fecha final#{self.date_end}")
        end

        if (Date.parse (self.date_start.strftime("%d-%m-%Y"))) < (Date.parse (self.order.date_start_planned.strftime("%d-%m-%Y")))
          errors.add(:date_start,"estimado usuario la fecha inicial no puede ser menor a la fecha inicial planificada#{self.order.date_start_planned}")
        end
        if (Date.parse (self.date_end.strftime("%d-%m-%Y"))) > (Date.parse (self.order.date_end_planned.strftime("%d-%m-%Y")))
          errors.add(:date_end,"estimado usuario la fecha final no puede ser mayor a la fecha final planificada#{self.order.date_end_planned}")
        end
      end
    end
  end

  def history
    HistoryAsignation.create(order_id:self.order_id,phase_id:self.phase_id,date_start:self.date_start,date_end:self.date_end,payment:self.payment,user_id:self.user_id,description:self.description,observation:self.observation,state_id:self.state_id,admin:self.admin,asignation_id:self.id)
  end

  def notification_create
    Notification.create(user:self.user_id,asignation:self.id,state:self.state.name,description:"Created Asignation")
  end
  def notification_update
    Notification.create(user:self.user_id,asignation:self.id,state:self.state.name,description:"Updated Asignation")
  end


 
  def self.search_field
    :order_id_or_phase_id_or_date_start_or_date_end_or_payment_or_user_id_or_description_or_observation_or_state_id_or_admin_cont
  end
end
