class Admin::MainController < ApplicationController
  permit "admin or site_admin"
end
