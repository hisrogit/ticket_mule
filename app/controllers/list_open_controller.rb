class ListOpenController < ApplicationController
  before_filter :set_current_tab
  layout "check_list"
  def index
    @tickets_per_page = tickets_per_page
    @closed_status = Status.closed.first
    @open_status = Status.open.first
    @tickets = Ticket.not_closed.paginate(
      :page => params[:page],
      :include => [:creator, :owner, :group, :status, :priority, :contact],
      :order => 'updated_at DESC',
      :per_page => @tickets_per_page        
    )
    @total_tickets = @tickets.total_entries
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.xml  { render :xml => @tickets }
    end
  end
  
  # Sets a cookie on the user's browser to indicate the tickets per page value
  def set_tickets_per_page
    @per_page = params[:per_page]
    cookies[:tickets_per_page] = { :value => "#{@per_page}", :expires => 1.year.from_now }
    flash[:success] = "You are now viewing #{@per_page} tickets per page!"
    redirect_to tickets_path
  end
  
  
  private   
    
  def set_current_tab
    @current_tab = :list_open
  end
end
