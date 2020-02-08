class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.uniq.pluck(:rating)
    if(params[:clear] == 'All') # Added so that session ID's can be cleared
      session[:sort] = nil
      session[:ratings] = nil
    end

    sortID = params[:sort].nil? ? session[:sort] : params[:sort]
    ratingsIDs = params[:ratings].nil? ? session[:ratings] : params[:ratings]
    
    if sortID == 'title'
      @title_header = 'hilite'
      @movies = ratingsIDs.present? ? Movie.order(sortID).where(rating: ratingsIDs.keys) : Movie.order(sortID)
      session[:sort] = sortID
      session[:ratings] = ratingsIDs if ratingsIDs.present?
    elsif sortID == 'release_date'
      @release_header = 'hilite'
      @movies = ratingsIDs.present? ? Movie.order(sortID).where(rating: ratingsIDs.keys) : Movie.order(sortID)
      session[:sort] = sortID
      session[:ratings] = ratingsIDs if ratingsIDs.present?
    elsif ratingsIDs.present?
      @movies = Movie.where(rating: ratingsIDs.keys)
      session[:ratings] = ratingsIDs
    end
    
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
  
end
