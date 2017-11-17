module App
  # BanksController
  class BanksController < AppController
    before_action :set_bank, only: [:show, :edit, :update, :destroy]
    before_action :validation_rol
    before_action :valid_cod

    def validation_rol
      if current_user.rol. != 'employee' 
        redirect_to :not_authorized
      end
    end
    # GET /banks
    # GET /banks.json
    def index
      @banks = Bank.all

    end

    # GET /banks/1
    # GET /banks/1.json
    def show
    end

    def valid_cod
     #@@bank = ""
    end


    # GET /banks/new
    def new
      @@bank = 0
      @banks = Bank.all
      if current_user.bank == nil
        @bank = Bank.new
        @type_account = ["Ahorro","Corriente"]
      elsif current_user.bank.stack_bank == nil
        redirect_to edit_bank_path
        
      else
        redirect_to new_experience_path
      end
    end
    

    # GET /banks/1/edit
    def edit
      @@bank = 0
      @type_account = ["Ahorro","Corriente"]
      if @bank.stack_bank == nil
        @bank.n_account = ""
        @bank.cod = ""
      end
    end
    def cod
      
      @@bank = @bank = StackBank.find(params[:stack_bank_id])
      respond_to do |format|
        format.js {}
      end
      
    end

    # POST /banks
    # POST /banks.json
    def create
      @type_account = ["Ahorro","Corriente"]
      @bank = Bank.new(bank_params)
      @bank.user_id = current_user.id
       if @@bank == 0
        @bank.codig = (nil)
      else
        @bank.cod = (@@bank.cod)
      end
     
      respond_to do |format|
        if @bank.save
          format.html { redirect_to new_experience_path, notice: 'Bank was successfully created.' }
          format.json { render :show, status: :created, location: @bank }
        else
          format.html { render :new }
          format.json { render json: @bank.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /banks/1
    # PATCH/PUT /banks/1.json
    def update
      @type_account = ["Ahorro","Corriente"]
      respond_to do |format|
        if @@bank == 0
            @bank.codig = (nil)
          else
            @bank.codig = (@@bank.cod)
          end
        if @bank.update(bank_params)
           

          format.html { redirect_to new_experience_path, notice: 'Bank was successfully updated.' }
          format.json { render :show, status: :ok, location: @bank }
        else
          format.html { render :edit }
          format.json { render json: @bank.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /banks/1
    # DELETE /banks/1.json
    def destroy
      @bank.destroy
      respond_to do |format|
        format.html { redirect_to banks_url, notice: 'Bank was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_bank
        @bank = Bank.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def bank_params
        params.require(:bank).permit(:stack_bank_id, :type_account, :n_account, :email_paypal)
      end
  end
end