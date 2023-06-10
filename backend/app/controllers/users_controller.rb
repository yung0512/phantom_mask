class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def top_n
    top_n = params[:top_n].to_i
    # find all user transaction total number in date range
    @users = User.all
    @user_transactions = MaskTransaction.where(purchase_at: params[:start_date]..params[:end_date]).group_by(&:user_id)
    @user_transaction_totals = @user_transactions.map { |k, v| [k, v.sum(&:amount)] }.to_h
    @user_transaction_totals = @user_transaction_totals.sort_by { |k, v| v }.reverse.to_h
    # return top n users
    @users = @users.select { |user| @user_transaction_totals.keys.include?(user.id) }.first(top_n)
    render(json: { users: @users})
  end
end