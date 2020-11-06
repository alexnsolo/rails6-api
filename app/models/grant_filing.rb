class GrantFiling < ApplicationRecord
  belongs_to :grant_filer
  has_many :grant_awards
end
