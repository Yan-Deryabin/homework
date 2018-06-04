class Rating < ApplicationRecord
  acts_as_copy_target

  belongs_to :product

  def self.for_date(date)
    sql = "SELECT *
           FROM ratings r
           WHERE r.analyse_date = '2018-06-05'
           AND product_id=64972"

    ActiveRecord::Base.connection.execute(sql)
  end
end

#<Product id: 64972, name: "Portable Side System">
#<Product id: 64973, name: "Disc Kit">

#<Rating id: 3000001, product_id: 64972, avg_rating: 0.17, rate_count: 78, analyse_date: "2018-06-04">
#<Rating id: 2000002, product_id: 64973, avg_rating: 3.32, rate_count: 64, analyse_date: "2018-06-03">

# join_approach = "SELECT r.*
#                  FROM ratings r
#                  INNER JOIN ( SELECT product_id, MAX(analyse_date) as max_analyse_date
#                               FROM ratings
#                               WHERE analyse_date < '2018-06-05'
#                               GROUP BY product_id
#                             ) rr
#                  ON r.product_id = rr.product_id
#                  AND r.analyse_date = rr.max_analyse_date"
#
# distinct_approach = "SELECT DISTINCT ON (product_id)
#                             id, avg_rating, product_id, analyse_date
#                      FROM ratings
#                      WHERE analyse_date < '2018-06-05'
#                      ORDER BY product_id, analyse_date DESC"
#
# result = ActiveRecord::Base.connection.execute(join_approach)
# result.to_a.size
#
# result = ActiveRecord::Base.connection.execute(distinct_approach)
# result.to_a.size
