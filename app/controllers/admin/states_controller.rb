module Admin
  # StatesController
  class StatesController < AdminController
    before_action :set_state, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /states
    def index
      @q = State.ransack(params[:q])
      states = @q.result(distinct: true)
      @objects = states.page(@current_page)
      @total = states.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to states_path(page: @current_page.to_i.pred, search: @query)
      end
    end

    # GET /states/1
    def show
    end

    # GET /states/new
    def new
      @state = State.new
    end

    # GET /states/1/edit
    def edit
      if ((@state.id > 0) and (@state.id < 5)) or (@state.asignation != nil)
        redirect_to admin_states_path, notice: "Este Status es propio del sistema
        "
      end
    end

    # POST /states
    def create
      @state = State.new(state_params)

      if @state.save
        redirect(@state, params)
      else
        render :new
      end
    end

    # PATCH/PUT /states/1
    def update
      if @state.update(state_params)
        redirect(@state, params)
      else
        render :edit
      end
    end

    def clone
      @state = State.clone_record params[:state_id]

      if @state.save
        redirect_to admin_states_path
      else
        render :new
      end
    end

    # DELETE /states/1
    def destroy
      if ((@state.id > 0) and (@state.id < 5)) or (@state.asignation != nil)
        redirect_to admin_states_path, notice: "No se puede elimiar este Status"
      else
        @state.destroy
        redirect_to admin_states_path, notice: actions_messages(@state)
      end
    end

    def destroy_multiple
      State.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_states_path(page: @current_page, search: @query),
        notice: actions_messages(State.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_state
      @state = State.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def state_params
      params.require(:state).permit(:name)
    end

    def show_history
      get_history(State)
    end
  end
end
