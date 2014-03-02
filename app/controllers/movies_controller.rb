class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    type = params[:type] #get movie type from URI route
    ratings = params[:ratings] #get movie ratings from URI route
    session_ratings = session[:ratings] 
    @all_ratings = ['G', 'PG','PG-13', 'R']
    if ratings.nil?
    	if session_ratings.nil?
    		keys = @all_ratings
    	else 
    		keys = session_ratings
    	end
    else 
    	keys = ratings.keys
    end
    @selected_ratings = keys
    @movies = Movie.all.find_all{|movie| @selected_ratings.include? movie.rating}				
    session[:ratings] = @selected_ratings
    case type
    when "sortname"
    	@movies = @movies.sort {|a,b| a.title <=> b.title}
    	@MTitle = "hilite"
    	@MDate = " "
    when "sortdate"
    	@movies = @movies.sort {|a,b| a.release_date <=> b.release_date}
    	@MDate = "hilite"
    	@MTitle = ""  
    end
  end    
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
