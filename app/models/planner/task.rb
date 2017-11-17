module Planner
 # Task Model
	class Task < ActiveRecord::Base
		establish_connection :slice_planner
		has_one :asignation
		has_one :history_asignation
		belongs_to :project
		belongs_to :phase
		def self.table_name
		 'tasks'
		end
 end
end