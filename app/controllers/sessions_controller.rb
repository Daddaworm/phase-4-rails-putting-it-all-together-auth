class SessionsController < ApplicationController

    # POST /login (Login feature)
    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id] = user.id 
            render json: user, status: :created
        else
            render json: { errors: ["Invalid Username or Password", "Unauthorized"] }, status: :unauthorized
        end
    end

    # DELETE /logout (Logout feature)
    def destroy
        if session[:user_id]
            session.delete :user_id
        else
            render json: { errors: ["You are not logged in"] }, status: :unauthorized
        end
    end

end
