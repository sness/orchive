class AdminRecordingsController < ApplicationController

  include AuthenticatedSystem
  before_filter :login_required

  layout 'admin'

  def index
    @recordings = Recording.find(:all, :order => "year")
  end

  def show
    @recording = Recording.find(params[:id])
  end

  def edit
    @recording = Recording.find(params[:id])
    if request.post?
      @recording.attributes = params[:recording]
      if @recording.save!
        flash[:notice] = 'Recording was successfully submitted.'
        redirect_to :action => 'edit', :id => params[:id]
      else
        flash[:notice] = 'Error in creating Recording.'
        render :action => 'edit', :id => params[:id]
      end
    end
  end

  def select_a_labbook_page_to_add_to_recording
    @recording = Recording.find(params[:id])
    @labbook_pages = LabbookPage.find(:all)
  end
  
  def add_labbook_page_to_recording
    @recording = Recording.find(params[:id])
    @labbook_page = LabbookPage.find(params[:labbook_page_id])
    @recording.labbook_pages << @labbook_page
    @recording.save!
    redirect_to :action => 'show', :id => @recording.id
  end


end
