class YelpApi

  # def db
  #   # @db = @db || Sqlite3.connection
  # end

  def self.client

    @client ||= Yelp::Client.new({ consumer_key: "Hdrg8_6u1liXxlUy9eZ_rQ",
                            consumer_secret: "YZRpBFph0iAC8uLR1rnCSwYvcxY",
                            token: "RCGkCDDMjd4fuEU_S0lNu0eqRNGKk-Ww",
                            token_secret: "4E0XdjKPGbBxS72Sb8MfZfgkIPk"
                          })

  end

  def self.search(location, terms, limit)
      client.search(location, terms, limit).businesses.map do |business|
        #binding.pry
        params = {name: business.name, address: business.location.address[0], url: business.url, rating: business.rating}
            if business.deals != nil
              params[:deals] = business.deals
              business.deals.each {|deal| deal.options.each {|option| params[:deals_title] = option.title}}
              business.deals.each {|deal| deal.options.each {|option| params[:deals_url] = option.purchase_url}}
            end 
              params[:categories] = []
                business.categories.each do |category|
                  category.each do |cat| 
                   if category.index(cat) % 2 == 0
                      cath = Category.find_or_create_by(name: cat)
                      params[:categories] << cath
           end
         end
       end

        Restaurant.create(params)
      end
  end
end