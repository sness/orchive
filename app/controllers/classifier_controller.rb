class ClassifierController < ApplicationController

  def index
    @classifiers = Classifier.paginate :page => params[:page]
  end

  def show
    @classifier = Classifier.find(params[:id])
    respond_to do |format|
      format.html
      format.text { render :text => @classifier.to_text }
    end
  end

  def create
    @annotations = Annotation.find(:all)
    if request.post?
      c = Classifier.new
      c.name = params[:classifier][:name]
      # sness - Need to set this to the currently logged in user
      c.user = User.find(1)
      params[:annotation].each do |k,v|
        a = Annotation.find(k)
        c.annotations << a
      end
      c.save!
      redirect_to :action => 'index'
    end
  end

  # Run a classifier on a set of recordings
  def run
    @recordings = Recording.find(:all)
  end

  def run_classifier
    @prediction = Prediction.new()
    
  end


end
