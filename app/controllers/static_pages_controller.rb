class StaticPagesController < ApplicationController
  def home
    unless logged_in?
      redirect_to login_url
      return
    end
    @tasks = current_user.tasks.paginate(page: params[:page]).per_page(10)
    @notes = current_user.notes.paginate(page: params[:page]).per_page(10)
    @page_title = "Home"
    @page_heading = "Checklist"
  end

  def about
    @page_title = "About"
  end

  def contact
    @page_title = "Contact"
  end
end
