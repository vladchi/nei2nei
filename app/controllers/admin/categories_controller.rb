class Admin::CategoriesController < ApplicationController
  permit "admin or site_admin"
  make_resourceful do
    actions :all
  end
end
