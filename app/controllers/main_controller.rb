class MainController < ApplicationController

  def index
  end

  def about
  end

  def tour
    @num_recordings = Recording.count(:all)
  end

  def player
  end

  def year_graph

    g = Gruff::Bar.new("700x400")
    g.title = "Number of tapes digitized by year"

    g.labels = Year.labels
    g.data(:Test, Year.data, "#008B00" )

    g.hide_legend = true
    g.minimum_value = 0
    g.maximum_value = Recording.max_digitized_in_a_year

    g.marker_font_size = 14

    send_data(g.to_blob,
              :disposition => 'inline',
              :type => 'image/png',
              :filename => "years.png")
  end

  def people
  end

end
