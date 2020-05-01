class Admin::MerchantsController < ApplicationController

  before_action :require_admin

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(merchant_params[:id])
    if merchant_params[:type]
      update = merchant_params[:type] == "enable" ? true : false
      @merchant.update(:active => update)
      @merchant.items.each { |item| item.update(:active? => update) }
      flash[:update] = "#{@merchant.name}'s account has been #{merchant_params[:type]}d."
      redirect_to "/admin/merchants"
    end
  end

  private

  def merchant_params
    params.permit(:type, :id)
  end
end
