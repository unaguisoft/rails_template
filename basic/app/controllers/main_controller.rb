class MainController < ApplicationController
  skip_before_action :require_login

  def home
  end
end