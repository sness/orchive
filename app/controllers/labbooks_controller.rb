class LabbooksController < ApplicationController

  include AuthenticatedSystem
  before_filter :get_years

  def get_years
    @years = Year.find(:all)

    @searching_for_recording = nil
    if (!session[:current_recording].nil? && session[:current_recording] != "")
      @searching_for_recording = Recording.find(session[:current_recording])
    end
  end

  def index
    @labbooks = Labbook.find(:all, :order => 'start_date')
  end

  def show
    @labbook = Labbook.find(params[:id])
    # For the left nav
    @labbooks = Labbook.find_all_within_year(@labbook.year)
    @current_year = @labbook.year
    @show_pages = true
  end

  def show_labbook_page
    @labbook_page = LabbookPage.find(params[:id])
    # For the left nav
    @labbooks = Labbook.find_all_within_year(@labbook_page.year)
    @labbook = @labbook_page.labbook
    @current_year = @labbook_page.year
    @show_pages = true
  end

  def show_big_labbook_page
    @labbook_page = LabbookPage.find(params[:id])
    # For the left nav
    @labbooks = Labbook.find_all_within_year(@labbook_page.year)
    @current_year = @labbook_page.year
    render :layout => 'application'
  end

  def year
    @labbooks = Labbook.find_all_within_year(params[:id])
    @current_year = params[:id]
  end

  def add_labbook_page_to_recording
    if session[:current_recording] != ""
      recording = Recording.find(session[:current_recording])
      lpr = LabbookPageRecording.new(:recording_id => recording.id, 
                                     :labbook_page_id => params[:id], 
                                     :user_id => current_user.id)
      lpr.save!
      flash[:notice] = "Successfully added labbook page to recording"
      session[:last_labbook_page] = params[:id]
      redirect_to :controller => 'recordings', :action => 'show', :id => session[:current_recording]
    else 
      flash[:notice] = "You are trying to set a lab book page but haven't yet chosen a recording."
      redirect_to :back
    end
  end

  def delete_labbook_page_from_recording
    lpr = LabbookPageRecording.find(:first, :conditions => { :recording_id => params[:id], :labbook_page_id => params[:labbook_page_id]})
    puts "********************"
    puts ":recording_id => #{params[:id]}"
    puts ":labbook_page_id => #{params[:labbook_page_id]}"
    puts "LabbookPageRecording => #{lpr}"
    flash[:notice] = "Successfully removed labbook page to recording"
    LabbookPageRecording.destroy(lpr.id)
    redirect_to :back
  end

end
