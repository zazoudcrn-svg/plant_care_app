require 'httparty'

class PerenualService
  BASE_URL = "https://perenual.com/api"

  def initialize
    @api_key = ENV.fetch('PERENUAL_API_KEY', nil)
  end

  def search_plant(species_name)
    return nil if species_name.blank?

    search_url = "#{BASE_URL}/species-list?key=#{@api_key}&q=#{URI.encode_www_form_component(species_name)}"
    response = HTTParty.get(search_url)

    if response.success? && response["data"].present?
      first_match = response["data"].first

      {
        common_name: first_match["common_name"],
        scientific_name: first_match["scientific_name"]&.join(", "),
        perenual_id: first_match["id"],
        note: "API basic match found successfully."
      }
    else
      nil
    end
  rescue StandardError => e
    Rails.logger.error "Perenual API Error: #{e.message}"
    nil
  end
end
