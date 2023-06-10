class User < ApplicationRecord
  has_many :mask_transactions

  validates :name, presence: true

end
