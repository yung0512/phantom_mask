class PharmacyMask < ApplicationRecord
  belongs_to :pharmacy
  belongs_to :mask
  has_many :mask_transactions
end
