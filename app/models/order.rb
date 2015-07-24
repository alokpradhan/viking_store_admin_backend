class Order < ActiveRecord::Base

  def self.in_last(days=nil)
    if days.nil?
      self.count
    else
      self.where('checkout_date > ?', DateTime.now - days).count
    end
  end

  def self.revenue_in_last(days=nil)
    if days.nil?
      revenue.where('orders.checkout_date NOT NULL').first.cost
    else
      revenue.where('orders.checkout_date > ?', DateTime.now - days).first.cost
    end
  end

  private
    def self.revenue
      self.select('SUM(products.price * order_contents.quantity) as cost').joins(
        'JOIN order_contents ON orders.id = order_contents.
        order_id JOIN products ON order_contents.product_id = products.id')
    end
end
