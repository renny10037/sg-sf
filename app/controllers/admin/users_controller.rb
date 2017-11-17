module Admin
  # UsersController
  class UsersController < AdminController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    def index
      @q = User.ransack(params[:q])
      users = @q.result(distinct: true).where('id != ?', current_user.id)
      @objects = users.page(@current_page)
      @total = users.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to users_path(page: @current_page.to_i.pred, search: @query)
      end
    end

    def new
      @user = User.new
    end

    def show
      if @user.id == 2
        redirect_to admin_users_path
      end
    end

    def edit
      if current_user.id != @user.id  
        redirect_to admin_users_path
      end
    end

    def update
      update_attributes = user_params.delete_if do |_, value|
        value.blank?
      end
      @user.before_rol = (@user.rol)
      if @user.update_attributes(update_attributes)
        redirect(@user, params)
      else
        render action: 'edit'
      end
    end

    def create
      @user = User.new(user_params)

      if @user.save
        @user.add_role Role.find(user_params.fetch(:role_ids)).name
        redirect(@user, params)
      else
        render action: 'new'
      end
    end

    def destroy
      if ((@user.asignations == nil) && (@user.asignations == []) && (@user.bank == nil) && (@user.bank == []) && (@user.experience == nil) && (@user.experience == []))
        @user.destroy
        redirect_to admin_users_path, notice: actions_messages(@user)
      else
         redirect_to admin_user_path(@user), notice: "No se puede eliminar este usuario"
      end
    end

    def destroy_multiple
      User.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_users_path(page: @current_page, search: @query),
        notice: actions_messages(User.new)
      )
    end
    def inspect 
      @user = User.find(params[:user_id])
      @banks = Bank.all
      @experiences = Experience.all
      respond_to do |format|
        format.html
        format.json
        format.pdf {render template: 'admin/users/pdf/inspect_report', pdf: 'Report_users'}
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name,:last_name,:nationality,:identification,:country_residence,:city,:address,:phone,:date_birt,:email,:password,:confirmationpassword,:role_ids,:encrypted_password)
    end

    def show_history
      get_history(User)
    end

    # Get submit key to redirect, only [:create, :update]
    def redirect(object, commit)
      if commit.key?('_save')
        redirect_to admin_user_path(object), notice: actions_messages(object)
      elsif commit.key?('_add_other')
        redirect_to new_admin_user_path, notice: actions_messages(object)
      elsif commit.key?('_assing_rol')
        redirect_to admin_users_path, notice: actions_messages(object)
      end
    end
  end
end
