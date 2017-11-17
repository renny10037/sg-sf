module App
  # UsersController
  class UsersController < AppController
    
    def pending
   		if current_user.rol != "pending"
    	  redirect_to not_authorized_path
   		end
    end

    def locked
      if current_user.rol != "locked"
    	  redirect_to not_authorized_path
   		end
    end
  end
end
