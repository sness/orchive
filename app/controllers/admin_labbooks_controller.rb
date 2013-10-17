class AdminLabbooksController < ApplicationController

  include AuthenticatedSystem
  layout 'admin'

  def index
    @labbooks = Labbook.find(:all)
  end

  def show
    @labbook = Labbook.find(params[:id])
  end

  def edit_labbook_page
    @labbook_page = LabbookPage.find(params[:id])
    if request.post?
      @labbook_page.attributes = params[:labbook_page]
      if @labbook_page.save!
        flash[:notice] = 'LabbookPage was successfully submitted.'
        redirect_to :action => 'edit_labbook_page', :id => params[:id]
      else
        flash[:notice] = 'Error in creating LabbookPage.'
        render :action => 'edit_labbook_page', :id => params[:id]
      end
    end
  end

  def view_labbook_page_image
    @labbook_page = LabbookPage.find(params[:id])
    render :layout => false
  end

  def select_a_recording_to_add_to_a_labbook_page
    @labbook_page = LabbookPage.find(params[:id])
    @recordings = Recording.find(:all)
  end
  
  def add_recording_to_labbook_page
    @labbook_page = LabbookPage.find(params[:id])
    @recording = Recording.find(params[:recording_id])
    @labbook_page.recordings << @recording
    @labbook_page.save!
    redirect_to :action => 'edit_labbook_page', :id => @labbook_page.id
  end

end
