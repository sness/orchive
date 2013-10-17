module ApplicationHelper

  def rollover_link(img_name,id,action,width,height)
    if (controller.action_name == id)
      state="selected"
    else
      state="normal"
    end

    if (controller.controller_name == "recordings") && (img_name == "orchive")
      state = "selected"
    end

    return "<a href=\"/#{action}\" " +
      "onMouseover=\"lightup(\'#{id}\');\" " + 
      "onMouseout=\"turnoff(\'#{id}\');\"> " + 
      "<img id=\"#{id}\" name=\"#{id}\" src=\"/images/buttons/#{state}_#{img_name}.jpg\" alt=\"\" width=\"#{width}\" height=\"#{height}\" />" +
      "</a>"
  end

end
