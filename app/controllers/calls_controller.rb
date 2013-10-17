class CallsController < ApplicationController

  def show
    @call = Call.find(params[:id])
    render :layout => false
  end

  # Snip out the desired section of audio from the audio file
  

  def dtw
    @calls = Call.find(:all, :conditions => {:call_type_id => '3'})
    render :layout => false
  end

end
