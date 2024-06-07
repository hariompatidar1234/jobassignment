class User < ApplicationRecord
  scope :total_gender, ->(gender){where(gender: gender)}
end
