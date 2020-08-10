class ShopsController < ApplicationController
skip_before_action :authenticate_user!, only: [ :index ]

  def index
      @shops = policy_scope(Shop)
      @products = Product.order("RANDOM()").first(10)
      @destacados = Shop.joins(:products).distinct.select('shops.*, COUNT(products.*) AS products_count').group('shops.id').order("products_count DESC")
  end

  def show
    @shop = Shop.find(params[:id])
    authorize @shop
    @products = Product.where(shop_id: @shop.id)
  end

  def new
    @shop = Shop.new
    authorize @shop
  end

  def create
    @shop = Shop.new(shop_params)
    if @shop.save
      flash[:success] = "Creado con exito"
      redirect_to @shop
    else
      flash[:error] = "Fallo"
      render 'new'
    end
    authorize @shop
  end

  def edit
    @shop = Shop.find(params[:id])
    authorize @shop
  end

  def update
  @shop = Shop.find(params[:id])
    if @shop.update_attributes(shop_params)
      flash[:success] = "Actualizado con exito"
      redirect_to @shop
    else
      flash[:error] = "Intenta nuevamente"
      render 'edit'
    end
    authorize @shop
  end

  def destroy
    @shop = Shop.find(params[:id])
    authorize @shop
    @shop.destroy
    redirect_to shops_path
  end

private
  def shop_params
    params.require(:shop).permit(:name, :address, :email, :phone_number, :user_id, :photo)
  end
end
