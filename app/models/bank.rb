class Bank < ActiveRecord::Base
	belongs_to :user
	belongs_to :stack_bank
	validates :stack_bank_id,:type_account, presence: true, if: :venezolan?
	validates :n_account, numericality: { only_integer: true }, if: :venezolan?
	validates :n_account, length: {is: 16}, presence: true, if: :venezolan?
	validates :email_paypal, presence: true
	
	def venezolan?
		if self.user.country_residence == "VE" or self.user.nationality == "VE" 
			return true
		end
	end
	
	#before_save :natio_residen

	def codig=(value)
		self.cod = value
	end

	#def natio_residen
	#	unless self.user.country_residence == "VE" or self.user.nationality == "VE" 
	 ##  	self.type_account = nil
	   # 	self.n_account = nil
	    #	self.cod = nil
		#end
	#end
end
