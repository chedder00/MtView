class StaticPagesController < ApplicationController

  skip_before_action :logged_in_user

  def home
    redirect_to login_url and return unless logged_in?
    @page_title = "Home"
    if(current_user.staff?)
      @tasks = current_user.tasks.sorted("DESC").page(params[:page]).per(10)
      @notes = current_user.notes.all.page(params[:page]).per(10)
      @page_heading = "Checklist"
    else
      @orders = current_user.orders.current.page(params[:page])
      @page_heading = "Open orders"
    end
  end

  def about
    @page_title = "About"
  end

  def contact
    @page_title = "Contact"
  end
end
