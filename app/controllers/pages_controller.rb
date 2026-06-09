class PagesController < ApplicationController
  # Devise - skipping login for some pages
  skip_before_action :authenticate_user!, only: :home
  def home
  end
end
