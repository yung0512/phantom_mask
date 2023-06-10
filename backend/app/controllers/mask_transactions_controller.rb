class MaskTransactionsController < ApplicationController
  def index
    @mask_transactions = MaskTransaction.all
  end

  # The total amount of masks and dollar value of transactions within a date range.
  def analysis
    # start_at: 2020-03-01
    # end_at: 2020-03-31
    @mask_transactions = MaskTransaction.where(purchase_at: params[:start_date]..params[:end_date])
    @total_masks = @mask_transactions.count # 一筆 transaction 一個 mask
    @total_dollars = @mask_transactions.sum(:amount).to_f

    render( json: {
      total_masks: @total_masks,
      total_dollars: @total_dollars
    })
  end

  def create
    # params:{
    #   user_id: 1,
    #   pharmacy_id: 1,
    #   pharmacy_mask_id: 1,
    #}

    # create a  as mask transaction
    # need to be done in a transaction
    ActiveRecord::Base.transaction do
      # check user cash balance is enough
      @user = User.find(params[:user_id])
      if @user.nil?
        return render(json: { error: 'User not found' }, status: :unprocessable_entity)
      end

      cost = PharmacyMask.find(params[:pharmacy_mask_id]).price

      if @user.cash_balance < cost
        return render(json: { error: 'User cash balance is not enough' }, status: :unprocessable_entity)
      else
        # create a mask transaction
        @mask_transaction = MaskTransaction.create!(
          user_id: params[:user_id],
          pharmacy_id: params[:pharmacy_id],
          pharmacy_mask_id: params[:pharmacy_mask_id],
          amount: cost,
          purchase_at: Time.now.to_datetime
        )
        # update pharmacy cash balance
        @pharmacy = Pharmacy.find(@mask_transaction.pharmacy_id)
        @pharmacy.update!(cash_balance: @pharmacy.cash_balance + @mask_transaction.amount)
        # update user cash balance
        @user.update!(cash_balance: @user.cash_balance - @mask_transaction.amount)
        render(json: @mask_transaction, status: :ok)
      end
    end
  end
end