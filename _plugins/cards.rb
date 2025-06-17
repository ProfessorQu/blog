# _plugins/cards.rb
require 'uri'
require 'net/http'

module Jekyll
  class CardTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @card_name = text
    end

    def render(context)
      uri = URI("https://api.scryfall.com/cards/named?exact=#{@card_name}")
      res = Net::HTTP.get_response(uri)
      if res.is_a?(Net::HTTPSuccess)
        json_resp = JSON.parse(res.body)
        url = json_resp['scryfall_uri']
        img_url = json_resp['image_uris']['normal']

        "<a class='card-link' href='#{url}'>#{@card_name}<img src='#{img_url}' class='card-img' alt=\"#{@card_name}\"></a>"
      else
        raise "Card not found: #{@card_name}"
      end
    end
  end

  class CardsBlock < Liquid::Block
    def render(context)
      content = ""

      images = super.strip
      images = images.split('!').drop(1)

      images.each { |img|
        name = img.match(/\[(.*)\]/).captures.first

        uri = URI("https://api.scryfall.com/cards/named?exact=#{name}")
        res = Net::HTTP.get_response(uri)

        if res.is_a?(Net::HTTPSuccess)
          img_url = JSON.parse(res.body)['image_uris']['large']
        else
          img_url = img.clone.match(/\((.*)\)/).captures.first
        end

        content += "<img src='#{img_url}' alt=\"#{name}\" class='card-img' loading='lazy'>"
      }

      "<div class='cards-container'>" + content + "</div>"
    end
  end
end

Liquid::Template.register_tag('card', Jekyll::CardTag)
Liquid::Template.register_tag('cards', Jekyll::CardsBlock)
