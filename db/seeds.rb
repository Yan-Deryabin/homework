require 'csv'

class TestDataImporter
  START_DATE = '1-06-2018'.to_date
  END_DATE   = '30-06-2018'.to_date

  DIR_NAME = "#{Rails.root}/tmp/seed/"

  CSV_PRODUCTS_PATH = "#{DIR_NAME}products.csv"
  CSV_RATINGS_PATH  = "#{DIR_NAME}ratings.csv"

  CSV_PRODUCTS_HEADER = %w[ name ]
  CSV_RATINGS_HEADER  = %w[ product_id avg_rating rate_count analyse_date ]

  def initialize
    FileUtils::mkdir_p(DIR_NAME) unless File.exists?(DIR_NAME)
    cleanup
  end

  def call
    create_products
    create_ratings
    cleanup
  end

  private

  def create_products
    CSV.open(CSV_PRODUCTS_PATH, 'wb') do |csv|
      csv << CSV_PRODUCTS_HEADER

      1_000_000.times do |index|
        csv << [FFaker::Product.product_name]
        puts "#{index} of 1_000_000" if (index % 10_000).zero?
      end
    end

    ::Product.copy_from CSV_PRODUCTS_PATH
  end

  def create_ratings
    CSV.open(CSV_RATINGS_PATH, 'wb') do |csv|
      csv << CSV_RATINGS_HEADER

      (START_DATE..END_DATE).each do |date|
        1_000_000.times do |product_id|
          csv << [
            product_id,
            rand(0.0..5.0).round(2),
            rand(100),
            date
          ]

          puts "#{date}: -- #{product_id} of 1_000_000" if (product_id % 10_000).zero?
        end
      end
    end

    ::Rating.copy_from CSV_RATINGS_PATH
  end

  def cleanup
    File.delete(CSV_PRODUCTS_PATH) if File.exists?(CSV_PRODUCTS_PATH)
    File.delete(CSV_RATINGS_PATH)  if File.exists?(CSV_RATINGS_PATH)
  end
end

TestDataImporter.new.call
