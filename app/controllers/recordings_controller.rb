class RecordingsController < ApplicationController

  include AuthenticatedSystem
  before_filter :login_from_cookie
#  before_filter :get_leftnav_years

  def get_leftnav_years
    @leftnav_years = Year.find(:all)
    @leftnav_recordings = Recording.find_all_by_year(params[:id], :order => 'tape + 0')
    @leftnav_current_year = params[:id]
  end

  def index
    years = Year.find(:all)
    @year_array = Array.new()
    years.each do |n|
      a = n.name
      b = Recording.count(:all, :conditions => { :year => n.name })
      @year_array.push([a,b])
    end
  end

  def show
    @recording = Recording.find(params[:id])
    # sness - Need to change this to just get the annotation for this user
    @annotations = @recording.annotations
    @visualizations = @recording.visualizations
    @predictions = @recording.predictions
    @users = @recording.users
    
    @call_array = []

    calls = Call.find(:all)
    @call_types = CallType.find(:all)

    @call_types.each do |call_type|
      a = []
      calls.each do |call|
        if call.name == call_type.name
          a << call
        end
      end
      @call_array << a
    end

    # Calculate maximums
    @max_call_types = 0
    @call_array.each do |row|
      if row.size > @max_call_types
        @max_call_types = row.size
      end
    end

    
    last = params[:id].to_i - 1
    if (last > 0)
      puts "************** last=#{last} *************"
      @prev_recording = Recording.find(last)
    end

    # Set mediaserver defaults to "get from main Orchive server"
    @current_user_mediaserver_url = ""
    @current_user_mediaserver_active = 0

    if current_user == :false || !current_user.can_annotate
      @current_annotation_user_id = -1
    else
      @current_annotation_user_id = current_user.id
      # Check if the current user gets their data through a mediaserver
      if current_user.mediaserver_active
        @current_user_mediaserver_active = 1
        @current_user_mediaserver_url = current_user.mediaserver_url
      else
        @current_user_mediaserver_active = 0
      end
    end
    @current_user_id = current_user.id

    @user_comments = RecordingComments.find(:first, :conditions => {:recording_id => params[:id], :user_id => current_user.id})
    @all_comments = RecordingComments.find(:all, :conditions => {:recording_id => params[:id]})
  end

  def upload_comments
    comments = RecordingComments.find(:first, :conditions => {:recording_id => params[:id], :user_id => params[:user_id]}) || RecordingComments.new
    comments.text = params[:comments]
    comments.recording_id = params[:id]
    comments.user_id = params[:user_id]
    comments.save!
                                      
    puts "********** upload_comments"
    redirect_to :back
  end

  def get_annotations
    @recording = Recording.find(params[:id])
    @annotations = @recording.annotations
    render :partial => 'annotation_table', :layout => false
  end

  def annotations
    annotations = Recording.find(params[:id]).user_annotations(params[:user_id])
    output = ""
    annotations.each do |n|
      output += n.to_string + "\n"
    end
    render :text => output
  end

  def audacity_annotations
    annotations = Recording.find(params[:id]).annotations
    output = ""
    annotations.each do |n|
      output += n.to_audacity
    end
    render :text => output
  end

  def find
    year = params[:year]

    params[:tape] =~ /([0-9]*)([A-B]*)/
    tape = $1
    side = $2

    # Try looking for the whole string
    r = Recording.find(:first, :conditions => {:year => year, :tape => tape, :side => side})

    # If we couldn't find anything, try just searching for the tape
    if (r.nil?)
      r = Recording.find(:first, :conditions => {:year => year, :tape => tape})
    end

    # If we couldn't find anything, try just searching for the year
    if (r.nil?)
      r = Recording.find(:first, :conditions => {:year => year})
    end


    if (r.nil?)
      redirect_to :action => 'show', :id => 1
    else
      redirect_to :action => 'show', :id => r.id
    end
  end

  def edit_time
    @recording = Recording.find(params[:id])
    if request.post?

      # Remember this time setting action
      # sness - Do this better in the future
      year = params[:recording]["start_time(1i)"]
      month = params[:recording]["start_time(2i)"]
      day = params[:recording]["start_time(3i)"]
      hour = params[:recording]["start_time(4i)"]
      minute = params[:recording]["start_time(5i)"]
      time = Time.gm(year,month,day,hour,minute)
      rst = RecordingStartTime.new(:recording_id => params[:id], 
                                   :user_id => current_user.id,
                                   :start_time => time)
      rst.save!

      @recording.attributes = params[:recording]
      if @recording.save!
        flash[:notice] = 'Recording was successfully submitted.'
        redirect_to :action => 'show', :id => params[:id]
      else
        flash[:notice] = 'Error in changing time.'
        render :action => 'edit_time', :id => params[:id]
      end
    end
  end

  def edit_labbook_page_recordings
    session[:current_recording] = params[:id]
    if (!session[:last_labbook_page].nil? && session[:last_labbook_page] != "")
      redirect_to "/labbooks/show_labbook_page/#{session[:last_labbook_page]}"
    else
      redirect_to :controller => 'labbooks', :action => 'index'
    end
  end


  ################################################################################
  ################################################################################
  ################################################################################



  def year
    @recordings = Recording.paginate :page => params[:page], :per_page => 200, :order => 'tape + 0', :conditions => { :year => params[:id] }
#    @recordings = Recording.find_all_by_year(params[:id])
    @current_year = params[:id]
  end


  #
  # Assets for orcasimplefftplay.swf
  #

  # mp3 asset for orcaannotator.swf
  def mp3_for_annotator
    @recording = Recording.find(params[:id])
    respond_to do |format|
      format.mp3 { 
        send_file RAILS_ROOT + "/public/" + @recording.mp3_audio_file_path
      }
    end
  end

  # waveform png asset for orcaannotator.swf
  def waveform_for_annotator
    @recording = Recording.find(params[:id])
    respond_to do |format|
      format.jpg { 
        send_file RAILS_ROOT + "/public/images/" + @recording.waveform_image_file_path
      }
    end
  end

  # spectrogram png asset for orcaannotator.swf
  def spectrogram_for_annotator
    @recording = Recording.find(params[:id])
    respond_to do |format|
      format.jpg { 
        send_file RAILS_ROOT + "/public/images/" + @recording.spectrogram_image_file_path
      }
    end
  end


  #
  # Predictions
  #
  def predictions
    predictions = Recording.find(params[:id]).user_predictions(params[:user_id])
    output = ""
    predictions.each do |n|
      output += n.to_string + "\n"
    end
    render :text => output
  end

end
