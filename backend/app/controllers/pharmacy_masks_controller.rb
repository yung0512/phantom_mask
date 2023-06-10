class PharmacyMasksController < ApplicationController
  def index
    pharmacy_id = params[:pharmacy_id]
    @pharmacy = Pharmacy.find(pharmacy_id)
    @pharmacy_masks = @pharmacy.pharmacy_masks.includes(:mask)

    if params[:sort_by].present? && params[:order].present?
      sort_by = params[:sort_by]  # price or mask_name
      order = params[:order] # asc or desc
      @pharmacy_masks = @pharmacy_masks.order("#{sort_by} #{order}") 

      # return result
      render(json: { pharmacy_masks: @pharmacy_masks.map { |pharmacy_mask| format_pharmacy_mask(pharmacy_mask) } })
    else
      # return result
      render(json: { pharmacy_masks: @pharmacy_masks.map { |pharmacy_mask| format_pharmacy_mask(pharmacy_mask) } })
    end
  end

  private
  def format_pharmacy_mask(pharmacy_mask)
    {
      id: pharmacy_mask.id,
      mask_name: pharmacy_mask.mask.name,
      price: pharmacy_mask.price,
      pharmacy_id: pharmacy_mask.pharmacy_id
    }
  end
end
