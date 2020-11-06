class FilingsController < ApplicationController
  
  def create
    filing_url = params[:filing_url]
    filing_id = FilingSerializer.serialize!(filing_url)
    filing = GrantFiling
      .where(id: filing_id)
      .includes(grant_awards: [:grant_recipient])
      .first
    
    response = {
      filing: {
        url: filing.url,
        tax_year: filing.tax_year,
        tax_period_begin_date: filing.tax_period_begin_date,
        tax_period_end_date: filing.tax_period_end_date,
        timestamp: filing.timestamp,
      },
      filer: {
        ein: filing.grant_filer.ein,
        name: filing.grant_filer.name,
        address: {
          line_1: filing.grant_filer.line_1,
          line_2: filing.grant_filer.line_2,
          city: filing.grant_filer.city,
          state: filing.grant_filer.state,
          zip_code: filing.grant_filer.zip_code,
        }
      },
      grants: filing.grant_awards.map do |grant_award|
        {
          recipient: {
            ein: grant_award.grant_recipient.ein,
            name: grant_award.grant_recipient.name,
            address: {
              line_1: grant_award.grant_recipient.line_1,
              line_2: grant_award.grant_recipient.line_2,
              city: grant_award.grant_recipient.city,
              state: grant_award.grant_recipient.state,
              zip_code: grant_award.grant_recipient.zip_code,
            }
          },
          amount: grant_award.amount,
          purpose: grant_award.purpose,
        }
      end
    }
    
    render json: response
  end
  
end
