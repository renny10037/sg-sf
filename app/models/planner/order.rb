module Planner
 # Order Model
 class Order < ActiveRecord::Base
	include ActivityHistory
	include CloneRecord
	establish_connection :slice_planner
	belongs_to :project
	has_one :percentage_cost
	has_many :asignations
	has_many :history_asignations
	def self.table_name
	 'orders'
	end
 end
end