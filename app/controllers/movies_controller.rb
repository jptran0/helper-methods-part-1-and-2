class MoviesController < ApplicationController
  def new
    @the_movie = Movie.new

    # We don’t actually need `template` because if you pass the render method a single string argument, it assumes that is a view template!
    #   render template: "movies/new"
    # If the folder name that the view templates are located inside of matches the name of the controller, and if the action name matches the name of the template, we can just get rid of the whole string
    #    render "movies/new"
  end

  def index
    @movies = Movie.order(created_at: :desc)

    respond_to do |format|
      format.json do
        render json: @movies
      end

      format.html do
      end
    end
  end

  def show
    # the `find_by` method does what the `where` method does except it automatically finds the first record
    # it will also return `nil` if the id isn't found
    # @the_movie = Movie.find_by(id: params.fetch(:id))

    # the `find` method only takes integers and assumes you are searching in the ID column
    # this method also returns a 404 page if the ID doesn't exist, which is the correct behavior instead of a 500 page from returning `nil`
    @movie = Movie.find(params.fetch(:id))
  end

  def create
    @movie = Movie.new
    @movie.title = params.fetch("query_title")
    @movie.description = params.fetch("query_description")

    if @movie.valid?
      @movie.save
      # we should only use paths on the client facing view templates, but when we’re sending responses back, we should use the fully qualified URL, including the domain name
      redirect_to movies_url, :notice => "Movie created successfully."
    else
      render template: "movies/new"
    end
  end

  def edit
    @movie = Movie.find(params.fetch(:id))
  end

  def update
    movie = Movie.find(params.fetch(:id))

    movie.title = params.fetch("query_title")
    movie.description = params.fetch("query_description")

    if movie.valid?
      movie.save
      redirect_to movie_url(movie), :notice => "Movie updated successfully."
    else
      redirect_to movie_url(movie), :alert => "Movie failed to update successfully."
    end
  end

  def destroy
    movie = Movie.find(params.fetch(:id))

    movie.destroy

    redirect_to movies_url, :notice => "Movie deleted successfully."
  end
end
