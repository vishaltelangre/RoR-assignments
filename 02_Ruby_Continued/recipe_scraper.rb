require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'mysql2'

#@client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => root)

###################### Category Index Page
@url = "http://www.simplyrecipes.com/"
@index_doc = Nokogiri::HTML(open(@url+"subject-index.php"))
@index_doc.xpath('//p/a').each do |category|

	# Save each category name
  @category_name = category.content
  # Save each category url
  @category_url = category["href"]

  ###################### Individual Category Page
  @category_doc = Nokogiri::HTML(open(@category_url))
  @category_doc.xpath('//div[@class="archive-entry-title"]/a').each do |recipe|

  	# Save each recipe url
    @recipe_url = recipe["href"]

    ###################### Individual Recipe Page
    @recipe_doc = Nokogiri::HTML(open(@recipe_url))
    # Save recipe name
    @recipe_name = @recipe_doc.xpath('//div[@class="hrecipe"]/span[@class="item"]/h1').text
    # Save recipe url
    @recipe_image_url = @recipe_doc.xpath('//div[@class="entry-photo"]/a/img').attr("src").text
    # Save recipe description
    @recipe_desc = @recipe_doc.xpath('//div[@id="recipe-intro"]').text
    # Save recipe ingredients
    @recipe_ingredient_array = []
    @recipe_doc.xpath('//li[@class="ingredient"]').each { |ingredient| @recipe_ingredient_array.push(ingredient.text) }
    @recipe_ingredients = @recipe_ingredient_array.join("|").to_s
    # Save recipe method
    @recipe_method = @recipe_doc.xpath('//div[@id="recipe-method"]').text
  end
end