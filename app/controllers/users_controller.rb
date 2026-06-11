# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to profile_path, notice: "Profile updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :user_location)
  end
end
