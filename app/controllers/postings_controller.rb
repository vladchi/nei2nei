class PostingsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :preload
  def preload;  load_object or build_object   end
  before_filter :ensure_current_posting_url, :only => :show
  before_filter :redirect_to_saved_search, :only => :index
  
  geocode_ip_address
  
  UPDATE_COND = "owner of :posting or admin or site_admin"

  permit UPDATE_COND, :only => [:edit, :update, :delete]
  
  make_resourceful do
    actions :all

    before :create do
      current_object.user = current_user
    end

    before :delete do
      debugger
    end

    response_for :create, :update do |format|
      format.html{redirect_to postings_path}
    end
  end

  def current_objects
    options = {:conditions => {}}
    if (params[:origin] && params[:within]) 
      
      options[:origin] = params[:origin]
      options[:within] = params[:within]
      session[:current_location_search] = {:origin => params[:origin], :within =>  params[:within]}
      
      options[:order] = 'distance'
      [:category, :posting_type].each do |col|
        options[:conditions][:"#{col.to_s}_id"] = params[col] if params[col]
      end
      Posting.all(options).paginate(:page => params[:page], :per_page => 10)
    else
      @show_search_advise = true
      [].paginate(:page => params[:page], :per_page => 10)
    end
  rescue Geokit::Geocoders::GeocodeError => e
    flash[:error] = "Unable to find location \"#{params[:origin]}\""
    [].paginate(:page => params[:page], :per_page => 10)
  end

  private
  
  def ensure_current_posting_url
    redirect_to @posting, :status => :moved_permanently if @posting.has_better_id?
  end

  def redirect_to_saved_search
    if session[:current_location_search] && !params[:origin] && !params[:within]
      redirect_to params.merge(session[:current_location_search])
    end
  end

end
