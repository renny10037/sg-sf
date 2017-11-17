class PaymentMailer < ApplicationMailer
	def new_payment(payment)
		@payment = payment
		mail(to: payment.asignation.user.email, subject: " New pago")
	end
	def edit_payment(payment)
		@payment = payment
		mail(to: payment.asignation.user.email, subject: " Edit pago")
	end
end
