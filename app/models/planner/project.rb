module Planner
 # Project Model
 class Project < ActiveRecord::Base
 	include ActivityHistory
 	include CloneRecord
   	establish_connection :slice_planner
   	has_many :tasks
   	has_many :orders
   	has_many :phases
   	def self.table_name
     'projects'
   	end
 end
end