module App
  # EmployeesController
  class EmployeesController < AppController
    before_action :validation_rol, :bank_exp

    def validation_rol
      if current_user.rol. != 'employee' 
        redirect_to :not_authorized
      end
    end

    def bank_exp
      if current_user.bank == nil 
        redirect_to new_bank_path
      elsif current_user.experience == nil 
        redirect_to new_experience_path
      end
    end

    def index
    	@banks = Bank.all
    	@users = User.all
    	@notifications = Notification.all
    end
    def asignation
      @asignations = Asignation.all
    end

    def partial_asignation
      @asignation = Asignation.find(params[:asignation_id])
      respond_to do |format|
        format.js {}
      end
    end

    def payment
      @asignations = Asignation.all
      @payments = Payment.all
    end

    def partial_payment
      @asignation = Asignation.find(params[:asignation_id])
      respond_to do |format|
        format.js {}
      end
    end

    def report  
      @asignations = Asignation.all
      @quant_payment = {Todos: '',Complet: '1', Inconplet:'0'}
      @users = User.all 
      @employee = []
      @users.each do |user|
        if user.rol. == 'employee'
          @employee << user
        end
      end
      @asignation = Asignation.new
      respond_to do |format|
        format.html
        format.pdf {render template: 'app/employees/pdf/report', pdf: "Report #{current_user.name} #{current_user.last_name}",
        tamaño_pagina: 'A4', font_size: '10px', layout: false, margin: {left: 0, right: 0}}
      end
      $bandera = 0
    end
    def create_report 
      @@bandera = 0
      $bandera = "1"
      $pdf = $bandera
      $bandera = "1"
      $date_start = ""
      $date_end = ""
      @asignations = Asignation.all
      $parametro = @asignation = Asignation.new(asignation_params)
      redirect_to app_employees_report_path
    end
     private

    # Use callbacks to share common setup or constraints between actions.
    def set_asignation
      @asignation = Asignation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def asignation_params
      params.require(:asignation).permit(:order_id, :phase_id, :date_start, :date_end, :payment, :user_id, :description, :observation, :state_id)
    end
  end
end
