class YelpApi

  def self.client

    @client ||= Yelp::Client.new({ consumer_key: "Hdrg8_6u1liXxlUy9eZ_rQ",
                            consumer_secret: "YZRpBFph0iAC8uLR1rnCSwYvcxY",
                            token: "RCGkCDDMjd4fuEU_S0lNu0eqRNGKk-Ww",
                            token_secret: "4E0XdjKPGbBxS72Sb8MfZfgkIPk"
                          })

  end

  def self.search(location, terms, limit)
      client.search(location, terms, limit).businesses.map do |business|
        params = {name: business.name, address: (business.location.address[0] + ", " + business.location.display_address[-1]), url: business.url, rating: business.rating, yelp_id: business.id}
            if business.deals != nil
#can't initalize with deals if there are no deals, probably don't need to collect entire deal data just the eaches? 
              params[:deals] = business.deals
              business.deals.each {|deal| deal.options.each {|option| params[:deals_title] = option.title}}
              business.deals.each {|deal| deal.options.each {|option| params[:deals_url] = option.purchase_url}}
            end 
              params[:categories] = []
                business.categories.each do |category|
                  category.each do |cat| 
                   if category.index(cat) % 2 == 0
#yelp categories come like [[Burger, burger], [Fast Food, fastfood]] so I have to iterate and select the capitalized versions 
                      cath = Category.find_or_create_by(name: cat)
                      params[:categories] << cath
           end
         end
       end
          #only place yelp_id is used - not displayed anywhere 
        if !Restaurant.find_by(yelp_id: params[:yelp_id])
          Restaurant.create(params)
        end 
      end
  end
end