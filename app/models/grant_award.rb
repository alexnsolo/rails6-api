class GrantAward < ApplicationRecord
  belongs_to :grant_recipient
  belongs_to :grant_filing
end
