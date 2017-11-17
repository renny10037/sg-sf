module Admin
  # PercentageCostsController
  class PercentageCostsController < AdminController
    before_action :set_percentage_cost, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]
    before_action :valid_order

    # GET /percentage_costs
    def index
      @q = PercentageCost.ransack(params[:q])
      percentage_costs = @q.result(distinct: true)
      @objects = percentage_costs.page(@current_page)
      @total = percentage_costs.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to percentage_costs_path(page: @current_page.to_i.pred, search: @query)
      end
    end

    # GET /percentage_costs/1
    def show
    end

    # GET /percentage_costs/new
    def new
      @percentage_cost = PercentageCost.new
      
    end
    def valid_order
      @orders = Planner::Order.all
      @total_order = []
       @orders.each do |order|
        if order.percentage_cost == nil
          @total_order << order
        end
      end
    end

    # GET /percentage_costs/1/edit
    def edit
     
    end

    # POST /percentage_costs
    def create
       @percentage_cost.create = (0)
      @percentage_cost = PercentageCost.new(percentage_cost_params)

      if @percentage_cost.save
        redirect(@percentage_cost, params)
      else
        render :new
      end
    end

    # PATCH/PUT /percentage_costs/1
    def update
      @percentage_cost.create = (@percentage_cost.quantify)
      if @percentage_cost.update(percentage_cost_params)
        redirect(@percentage_cost, params)
      else
        render :edit
      end
    end

    def clone
      @percentage_cost = PercentageCost.clone_record params[:percentage_cost_id]

      if @percentage_cost.save
        redirect_to admin_percentage_costs_path
      else
        render :new
      end
    end

    # DELETE /percentage_costs/1
    def destroy
      if (@percentage_cost.order.asignations == nil) or (@percentage_cost.order.asignations == []) 
        @percentage_cost.destroy
        redirect_to admin_percentage_costs_path, notice: actions_messages(@percentage_cost)
      else
        redirect_to admin_percentage_cost_path(@percentage_cost), notice: "No se puede eliinar este porcentage"
      end
    end

    def destroy_multiple
      PercentageCost.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_percentage_costs_path(page: @current_page, search: @query),
        notice: actions_messages(PercentageCost.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_percentage_cost
      @percentage_cost = PercentageCost.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def percentage_cost_params
      params.require(:percentage_cost).permit(:order_id, :quantify)
    end

    def show_history
      get_history(PercentageCost)
    end
  end
end
