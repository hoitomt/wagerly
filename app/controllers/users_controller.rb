class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @sportsbook = params[:sportsbook]
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice] = "#{@user.full_name} updated"
      redirect_to user_path(@user)
    else
      flash[:alert] = 'There was an error with the request'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:sportsbook_username, :sportsbook_password)
  end
end
