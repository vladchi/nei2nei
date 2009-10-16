class Admin::CategoriesController < ApplicationController
  make_resourceful do
    actions :all
  end
end
