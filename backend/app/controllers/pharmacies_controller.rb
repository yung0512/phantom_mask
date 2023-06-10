class PharmaciesController < ApplicationController
  def index
    # Initialize the query with all pharmacies
    @pharmacies = Pharmacy.all
    query = params[:query]
    # Filter by product quantity and price range if requested
    # {
    #   quantity: 10,
    #   min_price: 10.0,
    #   max_price: 20.0,
    #   op: 'gte' or 'lte'
    # }
    if !query.present?
      render(json: { pharmacies: @pharmacies.map { |pharmacy| format_pharmacy(pharmacy) } })
      return
    end

    if query[:quantity] && query[:min_price] && query[:max_price] && query[:op]
      quantity = query[:quantity].to_i
      min_price = query[:min_price].to_f
      max_price = query[:max_price].to_f
      op = query[:op]
      @pharmacies = @pharmacies.find_by_mask_quantity_and_price_range(min_price, max_price, quantity, op)
    end

    # Filter by open time and week day if requested
    # {
    #   week_day: 1,
    #   time: {
    #     hour: 10,
    #     minute: 30
    #   }
    # }
    if query[:week_day].present? && query[:time].present?
      week_day = query[:week_day]
      time = query[:time]
      @pharmacies = @pharmacies.find_by_week_day_and_time(week_day, time)
    end

    render(json: { pharmacies: @pharmacies.map { |pharmacy| format_pharmacy(pharmacy) } })
  end

  def show
  end

  private
  def format_pharmacy(pharmacy)
    {
      id: pharmacy.id,
      name: pharmacy.name,
      cash_balance: pharmacy.cash_balance,
      open_hours: pharmacy.open_hours
    }
  end
end
