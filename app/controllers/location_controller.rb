class LocationController < ApplicationController
  def update_coordinates
    respond_to do |format|
      format.js do
        current_loc = Location.new(:address_line => params[:address_line])
        current_loc.valid?
        render :partial => "/postings/googlemaps", :locals => {:start_location => current_loc}
      end
    end
  end
end
