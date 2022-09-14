class Api::CartItemsController < ApplicationController

    wrap_parameters include: CartItem.attribute_names + ['userId, productId']

    before_action :require_logged_in

    def index 
        @cart_items = current_user.cart_items
    end

    def create 
        # debugger
        # @cart_item = CartItem.create(cart_params)
        # @cart_items.each do |cart_item|
        #     if (cart_item.product_id === params[:cart_item][:product_id].to_i)
        #         cart_item.quantity += 1
        #         cart_item.save
        #         @cart_item = cart_item
        #         return
        #     end
        # end
        @cart_item = CartItem.new(cart_params)
        @cart_item.user_id = current_user.id
        # cart_item.quantity = 1
        if @cart_item.save!
            render :show
        else
            render json: {errors: ['Unable to add to cart.']}, status: 422;
        end
    end 


    def update 
        @cart_item = CartItem.find_by(id: params[:id])
        if @cart_item.update(cart_params)
            render :show
        else 
            render json: {errors: ['Unable to update cart.']}, status: 422;
        end
    end 

    def destroy
        @cart_item = CartItem.find(params[:id])
        if @cart_item.destroy
            render json: {message: 'Successfully removed from cart.'}
        end 
    end 

    private 

    def cart_params 
        params.require(:cart_item).permit(:product_id, :quantity, :user_id)
    end
end
