module Admin
  # PaymentsController
  class PaymentsController < AdminController
    before_action :set_payment, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /payments
    def index
      @asignations = Asignation.all
      @payments = Payment.all
      @q = Payment.ransack(params[:q])
      payments = @q.result(distinct: true)
      @objects = payments.page(@current_page)
      @total = payments.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to payments_path(page: @current_page.to_i.pred, search: @query)
      end
    end

    # GET /payments/1
    def show
    end

    # GET /payments/new
    def new
      @no_payments = []
      @users = User.all
      @asignations = Asignation.all
      @total_payment = []
      @asignations.each do |asignation|
        @quantify_payment = asignation.payments.inject(0) {|i,p| p.quantify + i}.to_f
        if (asignation.payment > @quantify_payment) and (asignation.state.id != 3)
          @total_payment << asignation 
        end
        if ((@quantify_payment == 0) and (asignation.user.id != 2) and (asignation.state.id != 3))
          @no_payments << asignation.id 
        end
      end
    end

    # GET /payments/1/edit
    def edit
      @edit_payment = @payment.asignation
      @no_payments = []
      @users = User.all
      @asignations = Asignation.all
      @total_payment = []
      @asignations.each do |asignation|
        @quantify_payment = asignation.payments.inject(0) {|i,p| p.quantify + i}.to_f
        if asignation.payment > @quantify_payment
          @total_payment << asignation  
        end
         if ((@quantify_payment == 0) and (asignation.user.id != 2) and (asignation.state.id != 3))
          @no_payments << asignation.id 
        end
        @total_payment.uniq << @payment.asignation
      end
     @total_payment << @edit_payment
    end

    # POST /payments
    def create
      @no_payments = []
      @users = User.all
      @asignations = Asignation.all
      @total_payment = []
      @asignations.each do |asignation|
        @quantify_payment = asignation.payments.inject(0) {|i,p| p.quantify + i}.to_f
        if asignation.payment > @quantify_payment
          @total_payment << asignation  
        end
       if ((@quantify_payment == 0) and (asignation.user.id != 2) and (asignation.state.id != 3))
          @no_payments << asignation.id 
        end
      end
      
      @payment.quantify_create = (0)
      @payment = Payment.new(payment_params)
      @payment.user_id = current_user.id
          
      if @payment.save
        redirect(@payment, params)
      else
        render :new
      end
    end

    # PATCH/PUT /payments/1
    def update
      @no_payments = []
      @users = User.all
      @asignations = Asignation.all
      @total_payment = []
      @asignations.each do |asignation|
        @quantify_payment = asignation.payments.inject(0) {|i,p| p.quantify + i}.to_f
        if asignation.payment > @quantify_payment
          @total_payment << asignation  
        end
        if ((@quantify_payment == 0) and (asignation.user.id != 2) and (asignation.state.id != 3))
          @no_payments << asignation.id 
        end
      end
      @payment.quantify_update = (@payment)
      if @payment.update(payment_params)
        redirect(@payment, params)
      else
        render :edit
      end
    end

    def clone
      @payment = Payment.clone_record params[:payment_id]

      if @payment.save
        redirect_to admin_payments_path
      else
        render :new
      end
    end

    # DELETE /payments/1
    def destroy
      @payment.destroy
      redirect_to admin_payments_path, notice: actions_messages(@payment)
    end

    def destroy_multiple
      Payment.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_payments_path(page: @current_page, search: @query),
        notice: actions_messages(Payment.new)
      )
    end
     def asignation
      @asignation = Asignation.find(params[:asignation_id])
      respond_to do |format|
        format.js {}
      end
    end
    def inspect
      @t_asignations = []
      @t_employee = []
      @payment = Payment.find(params[:payment_id])
      respond_to do |format|
        format.html
        format.json
        format.pdf {render template: 'admin/payments/pdf/inspect_report', pdf: 'Report_payments',
        tamaño_pagina: 'A4', font_size: '10px', layout: false, margin: {left: 0, right: 0}}
      end
    end
    def history
      @payment = Payment.find(params[:payment_id])
      @payments = Payment.all
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def payment_params
      params.require(:payment).permit(:asignation_id, :quantify, :description)
    end

    def show_history
      get_history(Payment)
    end
  end
end
