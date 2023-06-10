class Pharmacy < ApplicationRecord
  has_many :pharmacy_masks
  validates :cash_balance, presence: true
  validates :open_hours, presence: true

  # scope
scope :find_by_mask_quantity_and_price_range, -> (min_price, max_price, quantity, op) {
    includes(:pharmacy_masks).select do |pharmacy|
      pharmacy_masks_in_price_range = pharmacy.pharmacy_masks.select do |pharmacy_mask|
        min_price <= pharmacy_mask.price && pharmacy_mask.price <= max_price
      end
  
      case op
      when "gte"
        pharmacy_masks_in_price_range.size >= quantity
      when "lte"
        pharmacy_masks_in_price_range.size <= quantity
      else
        false
      end
    end
  }

  # week_day : 1~7
  # time : {hour: 0, min: 0}, week_day: 1~7
  scope :find_by_week_day_and_time, -> (week_day, time) {
    filter = lambda do |pharmacy|
      if pharmacy.open_hours["week_days"][week_day.to_s].present?
        interval = pharmacy.open_hours["week_days"][week_day.to_s]
        start_at = interval["start_at"]
        close_at = interval["close_at"]
  
        if start_at["hour"] < time[:hour] && time[:hour] < close_at["hour"]
          true
        elsif start_at["hour"] == time[:hour] && start_at["min"] <= time[:min]
          true
        elsif close_at["hour"] == time[:hour] && close_at["min"] >= time[:min]
          true
        else
          false
        end
      else
        false
      end
    end
  
    self.filter(&filter)
  }

  def cash_balance
    self[:cash_balance].to_f
  end

  def open_hours
    JSON.parse(self[:open_hours])
  end
end
