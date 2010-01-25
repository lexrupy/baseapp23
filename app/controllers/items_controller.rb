class ItemsController < ApplicationController
  def index
    @items = Item.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(params[:item])
    if @item.save
      flash[:notice] = t('items.create.flash.notice', :default => 'Item was successfully created.')
      redirect_to @item
    else
      render :action => "new"
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      flash[:notice] = t('items.update.flash.notice', :default => 'Item was successfully updated.')
      redirect_to @item
    else
      render :action => "edit"
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to item_url
  end
end

