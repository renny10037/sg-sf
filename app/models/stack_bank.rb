# StackBank Model
class StackBank < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  has_one :bank
  validates :name, :cod, presence: :true,uniqueness: true
  validates :cod, numericality: { only_integer: true }
  validates :cod, length: {is: 4}, presence: true
  validate :codigo
  #before_save :upcase_bank


  
  # def upcase_bank
  #   self.name = self.name.upcase!
  #  end

  def codigo
    if self.cod == nil or self.cod == "" 
      errors.add(:cod, "no puede estar en blanco")
  	elsif self.cod.to_i < 0 
  		errors.add(:cod, "el cod no puede ser negativo")
    end
    @cod = self.cod.split('').first.eql?('0')
    if @cod == false
      errors.add(:cod, "el cod debe empezar por 0")
    end
  end

  # Fields for the search form in the navbar
  def self.search_field
    :name_or_cod_cont
  end
end

