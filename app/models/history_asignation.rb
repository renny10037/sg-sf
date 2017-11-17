class HistoryAsignation < ActiveRecord::Base
	belongs_to :asignation
	belongs_to :user
  	belongs_to :state
	belongs_to :order, class_name: "Planner::Order"
  	belongs_to :phase, class_name: "Planner::Phase"
end
