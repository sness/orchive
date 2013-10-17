# == Schema Information
# Schema version: 20100420092914
#
# Table name: labbooks
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)     
#  start_date    :date            
#  end_date      :date            
#  pdf_file_path :string(255)     
#  created_at    :datetime        
#  updated_at    :datetime        
#

class Labbook < ActiveRecord::Base
  
  has_many :labbook_pages

  def self.find_all_within_year(year)
    y = Date.parse("01/01/#{year}")
    s = y.at_beginning_of_year
    e = y.at_end_of_year
    a = Labbook.find(:all, :conditions => {:start_date => s..e}, :order => :start_date)
    b = Labbook.find(:all, :conditions => {:end_date => s..e}, :order => :start_date)
     return (b + a).uniq
  end

  # sness - Hmm, this is just for displaying the _leftnav bar,
  # but somehow it feels a bit strange to do this.
  def year
    return end_date.year
  end

  # Return the maximum page number of this labbook
  def max_page_num
    # sness - A hack that relies on the fact that we have all the
    # labbook pages sorted.  There's probably a better way to do this.
    a = labbook_pages[-1].page
  end

end
