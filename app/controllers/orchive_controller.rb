class OrchiveController < ApplicationController

  def index
    if !params[:id].nil?
      @recording = Recording.find(params[:id])
    else
      @recording = Recording.find(1)
    end
  end

end
