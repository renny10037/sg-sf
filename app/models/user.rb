# User Model
class User < ActiveRecord::Base
  include ActivityHistory
  has_one :experience
  has_one :bank
  has_many :payments
  has_many :asignations
  has_many :updateasignations
  has_many :notifications
  before_save :create_permalink, if: :new_record?
  validates :phone,:identification, numericality: { only_integer: true }, on: :create
  #before_save :date
  rolify
  validates_presence_of :name, :email
  #:identification, :phone,:nationality,:last_name,:city
  after_create :user_rol
  after_create :send_mail_create
  after_update :send_mail_update

  # has_many :posts, dependent: :destroy relation posts
                    
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def rol
    roles.first.name
  end

  # Get the page number that the object belongs to
  def page(order = :id)
    ((self.class.order(order => :desc)
      .pluck(order).index(send(order)) + 1)
        .to_f / self.class.default_per_page).ceil
  end

  def self.search_field
    :name_or_username_or_email_cont
  end
  def user_rol
    if self.id == 1
      self.role_ids = '1'
    elsif self.id == 2
      self.role_ids = '2'
    elsif self.id == 3
      self.role_ids = '2'
    else
      self.role_ids = '3'
    end
  end

  # def date
  #   date_server = (Date.parse(Time.now.strftime("%d/%m/%Y")))
  #   years = (date_server.to_i) - (Date.parse (self.birthdate.strftime("%d-%m-%Y")))
  #   if years.to_i < 18 
  #     errors.add(:birthdate,"Esimado usuario, Usted es muy joven para trabajar en Slice Group")
  #   end
  # end

  def before_rol=(value)
    @before_rol = value
  end

  def after_rol=(value)
    @after_rol = value
  end
 
  def send_mail_create
    UserMailer.rol(self).deliver_later
  end

 def send_mail_update
  unless @before_rol == @after_rol
      UserMailer.rol(self).deliver_later
  end
 end
   
  private

  def create_permalink
    self.permalink = name.downcase.parameterize + '-' + SecureRandom.hex(4)
  end
end
