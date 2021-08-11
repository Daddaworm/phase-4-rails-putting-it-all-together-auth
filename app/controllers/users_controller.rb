class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response


    # POST /signup
    def create
        user = User.create!(user_params)
            session[:user_id] = user.id
            render json: user, status: :created
    end

    # GET /me (Auto-login feature)
    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user
        else
            render json: { error: "Not Authorized" }, status: :unauthorized
        end
    end


    private

    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end

    def render_not_found_response
        render json: { error: "User not found" }, status: :not_found
    end

end
