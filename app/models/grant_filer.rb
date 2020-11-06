class GrantFiler < ApplicationRecord
  has_one :address
  has_many :grant_filings
end
