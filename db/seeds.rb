require 'csv'

def create_products
  dir_name = "#{Rails.root}/tmp/seed/"
  csv_file_path = "#{dir_name}products.csv"
  csv_header = %w[ name ]

  File.delete(csv_file_path) if File.exists?(csv_file_path)
  FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

  CSV.open(csv_file_path, 'wb') do |csv|
    csv << csv_header

    1_000_000.times do |index|
      csv << [FFaker::Product.product_name]
      puts "#{index} of 1_000_000" if (index % 10_000).zero?
    end
  end

  ::Product.copy_from csv_file_path
  File.delete(csv_file_path) if File.exists?(csv_file_path)
end

def create_ratings
  dir_name = "#{Rails.root}/tmp/seed/"
  csv_file_path = "#{dir_name}ratings.csv"
  csv_header = %w[ product_id avg_rating rate_count analyse_date ]
  start_date = '1-06-2018'.to_date
  end_date = '7-06-2018'.to_date

  File.delete(csv_file_path) if File.exists?(csv_file_path)
  FileUtils::mkdir_p(dir_name) unless File.exists?(dir_name)

  CSV.open(csv_file_path, 'wb') do |csv|
    csv << csv_header

    (start_date..end_date).each do |date|
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

  ::Rating.copy_from csv_file_path
  File.delete(csv_file_path) if File.exists?(csv_file_path)
end

create_products
create_ratings
