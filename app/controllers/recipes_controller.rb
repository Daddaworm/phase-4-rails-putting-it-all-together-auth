class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    

    # GET /recipes (returns an array of recipes with their associated users)
    def index
        # byebug
        if current_user
            recipes = Recipe.all 
            render json: recipes
        else 
            render json: { errors: ["Not Authorized"] }, status: :unauthorized
        end
    end

    # GET /me
    def show
        recipe = Recipe.find_by(id: session[:user_id])
        if recipe
            render json: recipe 
        else
            render json: { error: "Not Authorized" }, status: :unauthorized
        end
    end

    # POST /recipes
    def create
        if session[:user_id]
            recipe = Recipe.create(recipe_params)
            recipe.update!(user_id: session[:user_id])
            render json: recipe, status: :created
        else
            render json: { errors: ["You must be logged in to create a recipie"] }, status: :unauthorized
        end
    end


    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end

    def render_not_found_response
        render json: { error: "Recipe not found" }, status: :not_found
    end


end
