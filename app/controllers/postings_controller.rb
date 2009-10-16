class PostingsController < ApplicationController
  geocode_ip_address
  
  make_resourceful do
    actions :all

    before :create do
      current_object.user = current_user
    end

    response_for :create, :update do |format|
      format.html{redirect_to postings_path}
    end
  end

  def current_objects
    options = {:conditions => {}}
    if params[:origin]
      options[:origin] = params[:origin]
      options[:order] = 'distance'
    end
    if params[:within]
      options[:within] = params[:within]
    end
    [:category, :posting_type].each do |col|
      options[:conditions][:"#{col.to_s}_id"] = params[col] if params[col]
    end
    Posting.all(options).paginate(:page => params[:page], :per_page => 10)
  rescue Geokit::Geocoders::GeocodeError => e
    flash[:error] = "Unable to find location \"#{params[:origin]}\""
    [].paginate(:page => params[:page], :per_page => 10)
  end

end
