module Admin
  # AsignationsController
  class AsignationsController < AdminController
    before_action :set_asignation, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]
    #@@parametro
    # GET /asignations
    def index
      @q = Asignation.ransack(params[:q])
      asignations = @q.result(distinct: true)
      @objects = asignations.page(@current_page)
      @total = asignations.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to asignations_path(page: @current_page.to_i.pred, search: @query)
      end
    end

    # GET /asignations/1
    def show
    end

    # GET /asignations/new
    def new
      @@edit = 0 
      @@edit_activity = 0
      @asignation = Asignation.new
      @orders = Planner::Order.all
      @phases = Planner::Phase.all
      @users = User.all
      @states = State.all
      @employee = []
      @users.each do |user|
        if user.rol. == 'employee'
          @employee << user 
        end
      end
    end

    # GET /asignations/1/edit
    def edit
      @@edit = 1
      @@edit_activity = @asignation.phase.id
      if @asignation.state.id == 3
        redirect_to admin_asignation_path(@asignation), notice:"No se puede editar esta asignacion debido a que ha sido removida"
      else
        
        @asignations = Asignation.all
        @orders = Planner::Order.all
        @phases = Planner::Phase.all
        @users = User.all
        @states = State.all
        @employee = []
        @sin_admin = []
        @sin_nomin = []
        @users.each do |user|
          if user.rol == 'employee'
            @sin_admin << user
          end
          if (user.rol == 'employee') and (user.id != 2)
            @sin_nomin << user 
          end
        end
        if (@asignation.payments.inject(0) {|i,p| p.quantify + i} != 0)
          @employee = @sin_nomin
        else
          @employee = @sin_admin
        end
        
        @states_disp = []
        @states.each do |state|
          if state.id != 3
            @states_disp << state
          end
        end
      end
      
    end

    # POST /asignations
    def create
      @orders = Planner::Order.all
      @phases = Planner::Phase.all
      @users = User.all
      @users = User.all
      @states = State.all
      @employee = []
      @users.each do |user|
        if user.rol. == 'employee'
          @employee << user 
        end
      end
      @asignation.create = (0)
      @asignation = Asignation.new(asignation_params)
      @asignation.admin = current_user.name
      @asignation.state_id = @state = '1'

      if @asignation.save
        redirect(@asignation, params)
      else
        render :new
      end
    end

    # PATCH/PUT /asignations/1
    def update
      @asignations = Asignation.all
      @orders = Planner::Order.all
      @phases = Planner::Phase.all
      @users = User.all
      @users = User.all
      @states = State.all

      @employee = []
      @sin_admin = []
      @sin_nomin = []
      @users.each do |user|
        if user.rol == 'employee'
          @sin_admin << user
        end
        if (user.rol == 'employee') and (user.id != 2)
          @sin_nomin << user
        end
      end
      if (@asignation.payments.inject(0) {|i,p| p.quantify + i} != 0)
        @employee = @sin_nomin
      else
        @employee = @sin_admin
      end
            @states_disp = []
              @states.each do |state|
                if state.id != 3
                  @states_disp << state
                end
              end
       @asignation.admin = current_user.name    
      @asignation.edit = (@asignation)
      if @asignation.update(asignation_params)
        redirect(@asignation, params)
      else
        render :edit
      end
    end

    def clone
      @asignation = Asignation.clone_record params[:asignation_id]

      if @asignation.save
        redirect_to admin_asignations_path
      else
        render :new
      end
    end

    # DELETE /asignations/1
    def destroy
      if (@asignation.payments == nil) or (@asignation.payments == [])
        @asignation.destroy
        redirect_to admin_asignations_path, notice: actions_messages(@asignation)
      else
        redirect_to admin_asignation_path(@asignation), notice:"No se puede eliminar esta asignation"
      end
    end

    def destroy_multiple
      Asignation.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_asignations_path(page: @current_page, search: @query),
        notice: actions_messages(Asignation.new)
      )
    end
    def order
      @edit_asignation = []
      @total = []
      @seleccionadas = []
      @@order = @order = Planner::Order.find(params[:order_id])
      respond_to do |format|
        format.js {}
      end
      @total_activity = []
      @order.project.phases.each do |phase|
        @total_activity << phase
        @total << phase.id
      end
      @order.asignations.each do |asignation|
        if asignation.state.id != 3
          if @@edit_activity != asignation.id
            @seleccionadas << @total_activity.delete(asignation.phase)
          end
        end
       end
      
    end
    def phase

      @phase = Planner::Phase.find(params[:phase_id])
      @order = @@order
      respond_to do |format|
        format.js {}
      end
    end
     def user
      @user = User.find(params[:user_id])
      respond_to do |format|
        format.js {}
      end
    end
    def inspect
      @t_asignations = []
      @t_employee = []
      @asignations = Asignation.all
      @asignation = Asignation.find(params[:asignation_id])
      respond_to do |format|
        format.html
        format.json
        format.pdf {render template: 'admin/asignations/pdf/inspect_report', pdf: 'Report_asignations',
        tamaño_pagina: 'A4', font_size: '10px', layout: false, margin: {left: 0, right: 0}}
      end
    end
    def history
      @asignation = Asignation.find(params[:asignation_id])
      @history_asignations = HistoryAsignation.all
    end

    def report  
      @quant_payment = {All: '',Complet: '1', Inconplet:'0'}
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
        format.pdf {render template: 'admin/asignations/pdf/report', pdf: 'Report_General',
        tamaño_pagina: 'A4', font_size: '10px', layout: false, margin: {left: 0, right: 0}}
        
      end
      $bandera = 0
    end
    def create_report 
      @@bandera = 0
      $bandera = "1"
      $pdf = $bandera
      @asignations = Asignation.all
      $parametro = @asignation = Asignation.new(asignation_params)
      redirect_to report_admin_asignations_path
    end

    def report_order
      @payments = Payment.all
      @asignations = Asignation.all
      @orders = Planner::Order.all
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

    def show_history
      get_history(Asignation)
    end
  end
end
