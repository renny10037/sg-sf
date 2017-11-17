module Planner
 # Phase Model
 class Phase < ActiveRecord::Base
	include ActivityHistory
	include CloneRecord
	establish_connection :slice_planner
	has_one :task
	belongs_to :project
	belongs_to :asignation
	belongs_to :history_asignation
	def self.table_name
	 'phases'
	end
 end
end