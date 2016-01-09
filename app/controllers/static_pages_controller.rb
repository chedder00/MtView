class StaticPagesController < ApplicationController

  def home
    redirect_to login_url and return unless logged_in?
    @page_title = "Home"
    if(current_user.staff?)
      @tasks = current_user.tasks.paginate(page: params[:page]).per_page(10)
      @notes = current_user.notes.paginate(page: params[:page]).per_page(10)
      @page_heading = "Checklist"
    else
      @orders = current_user.orders.current.paginate(page: params[:page])
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
