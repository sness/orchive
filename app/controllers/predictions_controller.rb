class PredictionsController < ApplicationController

  def index
    @predictions = Prediction.find(:all)
  end

  def show
    @prediction = Prediction.find(params[:id])
    respond_to do |format|
      format.html
      format.text { render :text => @prediction.data }
    end
  end

  def show_annotations
    @prediction = Prediction.find(params[:id])
    respond_to do |format|
      format.html
      format.text { render :text => @prediction.annotations_to_text }
    end
  end

  def make_new_prediction_from_recording
    @recording = Recording.find(params[:id])
    @annotations = @recording.annotations
    if request.post?
      p = Prediction.new
      # sness - Need to set this to the currently logged in user
      p.user = User.find(1)
      params[:annotation].each do |k,v|
        a = Annotation.find(k)
        p.annotations << a
      end
      p.status = 0
      p.recording_id = @recording.id
      p.save!
      redirect_to :action => 'index'
    end
  end

  def update_data
    @prediction = Prediction.find(params[:id])
    @prediction.data = params[:data]
    @prediction.save!
    render :text => "cool!  k thx bai"
  end

end
