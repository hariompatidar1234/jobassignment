class UsersController < ApplicationController
  def index
    users = User.all
    @users =  if params[:name]
                users.where('name LIKE ?', "%#{params[:name]}%")
              elsif params[:gender]
                users.where(gender: params[:gender])
              elsif params[:location]
                users.where('location LIKE ?', "%#{params[:location]}%")
              else
                users
              end
    render json: @users , message: "User data.",status: :ok
  end

  def destroy
     @user = User.find(params[:id])
     @user.destroy
     update_daily_record_counts

     render json: @user , message: "User data.",status: :ok
  end

  private

  def update_daily_record_counts
    male_count = User.where(gender: 'male').count
    female_count = User.where(gender: 'female').count
    daily_record = DailyRecord.last
    daily_record.update(male_count: male_count, female_count: female_count)
  end
end
