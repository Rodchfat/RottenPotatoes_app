class MoviesController < ApplicationController
helper_method :sort_column, :sort_direction
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  #this method for the rating form
  # def self.all_ratings
  #   @all_ratings = ['G','PG','PG-13','R']
  # end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
RATINGS = ['G','PG','PG-13','R']
  def index
    # Get ordered list of movies
    @movies = Movie.order(sort_column + ' ' + sort_direction)
    if !params[:ratings].nil?
      @movies = @movies.where(:rating => (params[:ratings]).keys)
    end
     # params[:ratings] -> {'G' => 1, 'PG' => 1}
     # params[:ratings].keys -> ['G', 'PG']
    # @movies = Movie.
    #   order(sort_column + ' ' + sort_direction).
    #   where(:rating => (params[:ratings]).keys)
     @all_ratings = Movie.all_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  def sort_direction
  %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
  def sort_column
  Movie.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end
  private
  def sort_column
    params[:sort] || "title"
  end
  
  def sort_direction
    params[:direction] || "asc"
  end

end
