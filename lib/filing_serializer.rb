require 'open-uri'

class FilingSerializer
  
  def initialize(filing_url)
    @filing_url = filing_url
  end
  
  def self.serialize!(filing_url)
    instance = self.new(filing_url)
    instance.serialize!
  end
  
  def serialize!
    doc = Nokogiri::XML(URI.open(@filing_url))
    
    # Serialize filing data, abort transaction on error so that all or none of the data is saved
    ActiveRecord::Base.transaction do
      filer_node = doc.search("Filer")
      
      # Find an existing grant filer by EIN, update with latest name and address, or create a new one
      filer_ein = get_text(filer_node, "EIN")
      filer = GrantFiler.find_or_create_by(ein: filer_ein) do |filer|
        filer_address_node = filer_node.search("USAddress")
        filer.name     = get_text(filer_node, "BusinessName BusinessNameLine1Txt")
        filer.line_1   = get_text(filer_address_node, "AddressLine1Txt")
        filer.line_2   = get_text(filer_address_node, "AddressLine2Txt")
        filer.city     = get_text(filer_address_node, "CityNm")
        filer.state    = get_text(filer_address_node, "StateAbbreviationCd")
        filer.zip_code = get_text(filer_address_node, "ZIPCd")
      end
      
      # Find or create a grant filing with the given params
      filing = GrantFiling.find_or_create_by(url: @filing_url) do |filing|
        filing.tax_year              = get_integer(doc, "TaxYr")
        filing.tax_period_begin_date = get_date(doc, "TaxPeriodEndDt")    
        filing.tax_period_end_date   = get_date(doc, "TaxPeriodBeginDt")
        filing.grant_filer_id        = filer.id
      end
      
      # Clear out the filings existing awards (if any) and create new ones
      GrantAward.where(grant_filing_id: filing.id).delete_all
      
      award_nodes = doc.search("IRS990ScheduleI RecipientTable")
      award_nodes.take(2).each do |award_node|
        # Find an existing grant recipient by EIN, update with latest name and address, or create a new one
        recipient_ein = get_text(award_node, "RecipientEIN")
        recipient = GrantRecipient.find_or_create_by(ein: recipient_ein) do |recipient|
          receipient_address_node = award_node.search("USAddress")
          recipient.name     = get_text(award_node, "RecipientBusinessName BusinessNameLine1Txt")
          recipient.line_1   = get_text(receipient_address_node, "AddressLine1Txt")
          recipient.line_2   = get_text(receipient_address_node, "AddressLine2Txt")
          recipient.city     = get_text(receipient_address_node, "CityNm")
          recipient.state    = get_text(receipient_address_node, "StateAbbreviationCd")
          recipient.zip_code = get_text(receipient_address_node, "ZIPCd")
        end
        
        # Create grant award
        GrantAward.create(
          grant_recipient:  recipient,
          grant_filing:     filing,
          amount:           get_float(award_node, "CashGrantAmt"),
          purpose:          get_text(award_node, "PurposeOfGrantTxt"),
        )
      end
    end
    
    nil
  end
  
  def get_text(node, path)
    result = node.search(path)
    result.text if result
  end
  
  def get_integer(node, path)
    result = node.search(path)
    result.text.to_i if result
  end
  
  def get_float(node, path)
    result = node.search(path)
    result.text.to_f if result
  end
  
  def get_date(node, path)
    result = node.search(path)
    Date.parse(result.text) if result
  end
  
end