class StackBankMailer < ApplicationMailer
	def destroy_stack_bank(stack_bank)
		@stack_bank = stack_bank
		mail(to: stack_bank.bank.user.email, subject: " Edit bank")
	end
end
