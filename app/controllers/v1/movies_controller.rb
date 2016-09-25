module V1
  class MoviesController < ApplicationController
    include MoviesDoc

    before_action :set_movie, only: [:show, :update, :destroy]

    def index
      @movies = current_user.movies

      render json: serialize_models(@movies, namespace: V1)
    end

    def show
      render json: serialize_model(@movie, namespace: V1)
    end

    def create
      @movie = current_user.movies.new(movie_params)

      if @movie.save
        render json: serialize_model(@movie, namespace: V1), status: :created
      else
        render json: serialize_errors(@movie.errors), status: :unprocessable_entity
      end
    end

    def update
      if @movie.restart
        render json: serialize_model(@movie, namespace: V1), status: :created
      else
        render json: serialize_errors(@movie.errors), status: :unprocessable_entity
      end
    end

    def destroy
      @movie.destroy
    end

    private
    def set_movie
      @movie = current_user.movies.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:start_time, :end_time, :file)
    end
  end
end
