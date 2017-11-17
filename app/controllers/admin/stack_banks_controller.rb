module Admin
  # StackBanksController
  class StackBanksController < AdminController
    before_action :set_stack_bank, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /stack_banks
    def index
      @q = StackBank.ransack(params[:q])
      stack_banks = @q.result(distinct: true)
      @objects = stack_banks.page(@current_page)
      @total = stack_banks.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to stack_banks_path(page: @current_page.to_i.pred, search: @query)
      end
    end

    # GET /stack_banks/1
    def show
    end

    # GET /stack_banks/new
    def new
      @stack_bank = StackBank.new
      @stack_banks = StackBank.all
    end

    # GET /stack_banks/1/edit
    def edit
    end

    # POST /stack_banks
    def create
      @stack_bank = StackBank.new(stack_bank_params)

      if @stack_bank.save
        redirect(@stack_bank, params)
      else
        render :new
      end
    end

    # PATCH/PUT /stack_banks/1
    def update
      if @stack_bank.update(stack_bank_params)
        redirect(@stack_bank, params)
      else
        render :edit
      end
    end

    def clone
      @stack_bank = StackBank.clone_record params[:stack_bank_id]

      if @stack_bank.save
        redirect_to admin_stack_banks_path
      else
        render :new
      end
    end

    # DELETE /stack_banks/1
    def destroy
      # if (@stack_bank.bank == nil) or (@stack_bank.bank == [])
        @stack_bank.destroy
        redirect_to admin_stack_banks_path, notice: actions_messages(@stack_bank)
      #else
       # redirect_to admin_stack_bank_path(@stack_bank), notice: "-no se puede eliminar este Stock"
      #end
    end

    def destroy_multiple
      StackBank.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_stack_banks_path(page: @current_page, search: @query),
        notice: actions_messages(StackBank.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_stack_bank
      @stack_bank = StackBank.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def stack_bank_params
      params.require(:stack_bank).permit(:name, :cod)
    end

    def show_history
      get_history(StackBank)
    end
  end
end
