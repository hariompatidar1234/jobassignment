require 'httparty'
require 'sidekiq'

class FetchUsersJob
  include Sidekiq::Worker

  sidekiq_options retry: true, retry_exceptions: [SocketError]

  def perform
    fetch_users_from_api
    update_gender_counts
  rescue => e
    Rails.logger.error("Error in FetchUsersJob: #{e.message}")
    # You can also notify someone or log the error in a more robust way
  end

  private

  def fetch_users_from_api
    retry_count = 0
    begin
      response = HTTParty.get("https://randomuser.me/api/?results=20")
      users = response.parsed_response["results"]

      users.each do |user_data|
        user = User.new(
          uuid: user_data["login"]["uuid"],
          gender: user_data["gender"],
          name: user_data["name"],
          location: user_data["location"],
          age: user_data["dob"]["age"]
        )
        if existing_user = User.find_by(uuid: user.uuid)
          existing_user.update!(name: user['name']['first'], age: user['dob']['age'], gender: user['gender'])
        else
          user.save!
        end
      end
    rescue SocketError => e
      if retry_count < 3
        retry_count += 1
        Rails.logger.warn("Retry #{retry_count} due to SocketError: #{e.message}")
        sleep 1
        retry
      else
        raise e
      end
    end
  end

  def update_gender_counts
    redis = Redis.new
    male_count = User.total_gender('male').count
    female_count = User.total_gender('female').count
    redis.set('male_count', male_count)
    redis.set('female_count', female_count)
  end
end
