class MoviesController < ApplicationController
  def new
    @the_movie = Movie.new

    # We don’t actually need `template` because if you pass the render method a single string argument, it assumes that is a view template!
    #   render template: "movies/new"
    # If the folder name that the view templates are located inside of matches the name of the controller, and if the action name matches the name of the template, we can just get rid of the whole string
    #    render "movies/new"
  end

  def index
    matching_movies = Movie.all

    @list_of_movies = matching_movies.order(:created_at => :desc)

    respond_to do |format|
      format.json do
        render json: @list_of_movies
      end

      format.html do
      end
    end
  end

  def show
    the_id = params.fetch(:id)

    matching_movies = Movie.where(:id => the_id)

    @the_movie = matching_movies.first
  end

  def create
    @the_movie = Movie.new
    @the_movie.title = params.fetch("query_title")
    @the_movie.description = params.fetch("query_description")

    if @the_movie.valid?
      @the_movie.save
      # we should only use paths on the client facing view templates, but when we’re sending responses back, we should use the fully qualified URL, including the domain name
      redirect_to movies_url, :notice => "Movie created successfully."
    else
      render template: "movies/new"
    end
  end

  def edit
    the_id = params.fetch(:id)

    matching_movies = Movie.where(:id => the_id)

    @the_movie = matching_movies.first
  end

  def update
    the_id = params.fetch(:id)
    the_movie = Movie.where(:id => the_id).first

    the_movie.title = params.fetch("query_title")
    the_movie.description = params.fetch("query_description")

    if the_movie.valid?
      the_movie.save
      redirect_to movie_url(the_movie), :notice => "Movie updated successfully."
    else
      redirect_to movie_url(the_movie), :alert => "Movie failed to update successfully."
    end
  end

  def destroy
    the_id = params.fetch(:id)
    the_movie = Movie.where(:id => the_id).first

    the_movie.destroy

    redirect_to movies_url, :notice => "Movie deleted successfully."
  end
end
