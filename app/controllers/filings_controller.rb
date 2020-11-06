class FilingsController < ApplicationController
  
  def create
    filing_url = params[:filing_url]
    FilingSerializer.serialize!(filing_url)
    
    render status: 200
  end
  
end
