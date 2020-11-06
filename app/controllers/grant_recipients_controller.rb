class GrantRecipientsController < ApplicationController
  
  def index
    filter_ein = params[:ein]
    filter_city = params[:city]
    filter_state = params[:state]
    filter_zip_code = params[:zip_code]
    
    recipients = GrantRecipient
    recipients = recipients.where(ein: filter_ein) if filter_ein
    recipients = recipients.where(city: filter_city) if filter_city
    recipients = recipients.where(state: filter_state) if filter_state
    recipients = recipients.where(zip_code: filter_zip_code) if filter_zip_code
    recipients = recipients.all
    
    response = recipients.map do |recipient|
      {
        ein: recipient.ein,
        name: recipient.name,
        address: {
          line_1: recipient.line_1,
          line_2: recipient.line_2,
          city: recipient.city,
          state: recipient.state,
          zip_code: recipient.zip_code,
        }
      }
    end
      
    render json: response
  end
  
end
