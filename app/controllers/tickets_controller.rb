class TicketsController < ApplicationController
  before_filter :require_user
  before_filter :set_current_tab
  before_filter :lookup_ticket, :only => [:edit, :update, :destroy]
  before_filter :require_admin, :only => [:destroy]
  before_filter :get_alert, :only => [:show]
  cache_sweeper :audit_sweeper
  skip_before_filter :verify_authenticity_token,:only => [:generate_contact]
  
  def generate_contact
    
    rs = Contact.find(
		  :all,
		  :conditions => "group_id = #{params[:id]}"
		).collect {|p|[ p.full_name, p.id ]}
    
    str = '<select name="ticket[contact_id]" id="ticket_contact_id"><option value="">------</option>'
    rs.each {|v|
      str += "<option value='#{v[1]}'>#{v[0]}</option>"
    }
    str += "</select>"
    
    
    render :text => str
    #render :update do |page|      
    #    page.replace_html 'contact_ajax', select(
    #                                          'ticket', 
    #                                          'contact_id', 
    #                                          Contact.find(
    #                                                      :all,
    #                                                      :conditions => "group_id = #{params[:id]}"
    #                                                    ).collect {|p|[ p.full_name, p.id ]}, 
    #                                          {:include_blank => '------'}
    #                                        )   
    #end
  end

  def index
    @tickets_per_page = tickets_per_page
    @search = Ticket.search(params[:search])
    @closed_status = Status.closed.first
    @open_status = Status.open.first

    if params[:search]
      if !params[:search][:created_at_gte].blank?
        start_date = Date.strptime(params[:search][:created_at_gte],"%Y-%m-%d")
        @search.created_at_gte = start_date
        start_date = start_date.midnight.gmtime
        params[:search][:created_at_gte] = start_date.midnight
      end
      if !params[:search][:created_at_lt].blank?
        end_date = Date.strptime(params[:search][:created_at_lt],"%Y-%m-%d")
        @search.created_at_lt = end_date
        end_date = end_date.next.midnight.gmtime
        params[:search][:created_at_lt] = end_date.midnight
      end
      search_tmp = (params[:search][:owned_by_equals].nil?)? "":" and owned_by = '#{params[:search][:owned_by_equals]}'"
      search_tmp2 = (!@current_user.admin and !@current_user.staff and !@current_user.it)? " or group_id = '#{ @current_user.group_id}'":""
      #@tickets = Ticket.search(params[:search]).paginate(
      @tickets = Ticket.paginate(
        :page => params[:page],
        :include => [:creator, :owner, :group, :status, :priority, :contact],
        :order => 'updated_at DESC',
        :per_page => @tickets_per_page,
	#:conditions =>(@current_user.admin)? "":"(owned_by = '#{ @current_user.id}' or created_by = '#{ @current_user.id}' #{search_tmp2}) and status_id = '#{params[:search][:status_id_equals]}'")
:conditions =>(@current_user.admin)? "status_id = '#{params[:search][:status_id_equals]}'" + search_tmp:"(owned_by = '#{ @current_user.id}' or created_by = '#{ @current_user.id}' or group_id = '#{ @current_user.group_id}') and status_id = '#{params[:search][:status_id_equals]}'")
    else
      search_tmp2 = (!@current_user.admin and !@current_user.staff and !@current_user.it)? " or group_id = '#{ @current_user.group_id}'":""
      #@tickets = Ticket.not_closed.paginate(
      @tickets = Ticket.paginate(
        :page => params[:page],
        :include => [:creator, :owner, :group, :status, :priority, :contact],
        :order => 'updated_at DESC',
        :per_page => @tickets_per_page,
:conditions =>(@current_user.admin or @current_user.staff)? "status_id != '#{@closed_status.id}'":"(owned_by = '#{@current_user.id}' or created_by = '#{@current_user.id}' #{search_tmp2})  and status_id != '#{@closed_status.id}' ")
    end

    @total_tickets = @tickets.total_entries

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.xml  { render :xml => @tickets }
    end
  end

  def show
    begin
      @ticket = Ticket.find(params[:id], :include => { :comments => :user, :attachments => :user })
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid ticket_id => #{params[:id]}")
      flash[:error] = "You have requested an invalid ticket!"
      redirect_to tickets_path and return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.pdf { render :layout => false }
      format.xml  { render :xml => @ticket }
    end
  end

  def new
    @ticket = Ticket.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  def edit
  end

  def create
    # scope creation of new ticket to current_user
    @ticket = @current_user.created_tickets.build(params[:ticket])

    respond_to do |format|
      if @ticket.save
        flash[:success] = "Ticket ##{@ticket.id} was successfully created!"
        format.html { redirect_to(@ticket) }
        format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        flash[:success] = 'Ticket was successfully updated!'
        format.html { redirect_to(@ticket) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
      format.xml  { head :ok }
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

  def lookup_ticket
    begin
      @ticket = Ticket.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid ticket_id => #{params[:id]}")
      flash[:error] = "You have requested an invalid ticket!"
      redirect_to tickets_path and return
    end
  end

  def set_current_tab
    @current_tab = :tickets
  end

  def get_alert
    @alert = Alert.find_by_user_id_and_ticket_id(@current_user.id, params[:id])
  end


end
