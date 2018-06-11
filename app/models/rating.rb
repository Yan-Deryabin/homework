# Deleted 5-06

class Rating < ApplicationRecord
  acts_as_copy_target

  belongs_to :product

  class << self
    def benchmark(date)
      Benchmark.bm(7) do |x|
        x.report('join_approach:    ') { join_approach(date) }
        x.report('distinct_approach:') { distinct_approach(date) }
      end
    end

    def join_approach(date)
      ActiveRecord::Base.connection.execute("
        SELECT r.*
        FROM ratings r
        INNER JOIN ( SELECT product_id, MAX(analyse_date) as max_analyse_date
                     FROM ratings
                     WHERE analyse_date < '#{date}'
                     GROUP BY product_id
                   ) rr
        ON r.product_id = rr.product_id
        AND r.analyse_date = rr.max_analyse_date
      ")
    end

    def distinct_approach(date)
      ActiveRecord::Base.connection.execute("
        SELECT DISTINCT ON (product_id)
               id, avg_rating, product_id, analyse_date
        FROM ratings
        WHERE analyse_date < '#{date}'
        ORDER BY product_id, analyse_date DESC
      ")
    end
  end
end
