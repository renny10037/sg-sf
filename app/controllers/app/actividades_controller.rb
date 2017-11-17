module App
  # ActividadesController
  class ActividadesController < AppController
    def new
    @banks = Bank.all
    @users = User.all
    @notifications = Notification.all
  end
  end
end
