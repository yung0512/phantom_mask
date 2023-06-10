class MaskTransaction < ApplicationRecord
  def amount
    self[:amount].to_f
  end
end
