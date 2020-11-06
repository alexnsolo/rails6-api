class GrantRecipient < ApplicationRecord
  has_one :address
  has_many :grant_awards
end
