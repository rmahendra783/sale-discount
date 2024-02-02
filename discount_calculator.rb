class DiscountCalculator
  PRICING_TABLE = {
    'Milk' => { unit_price: 3.97, sale_price_quantity: 2, sale_price: 5.00 },
    'Bread' => { unit_price: 2.17, sale_price_quantity: 3, sale_price: 6.00 },
    'Banana' => { unit_price: 0.99, sale_price_quantity: nil, sale_price: nil },
    'Apple' => { unit_price: 0.89, sale_price_quantity: nil, sale_price: nil }
  }.freeze

  def initialize(items)
    @items = items
    @item_counts = Hash.new(0)
  end

  def calculate_discount
    @items.each { |item| @item_counts[item.capitalize] += 1 }
    total_price = 0.0

    puts "Item     Quantity      Price"
    puts "--------------------------------------"

    @item_counts.each do |item, quantity|
      pricing_info = PRICING_TABLE[item]
      price = calculate_price(pricing_info, quantity)
      total_price += price

      puts "#{item.ljust(9)}#{quantity.to_s.ljust(13)}$#{'%.2f' % price}"
    end

    puts "\nTotal price : $#{'%.2f' % total_price}"
    puts "You saved $#{'%.2f' % (calculate_saved_amount - total_price)} today."
  end

  private

  def calculate_price(pricing_info, quantity)
    return 0.0 if quantity.zero?

    if pricing_info[:sale_price_quantity] && pricing_info[:sale_price]
      sale_quantity = (quantity / pricing_info[:sale_price_quantity]) * pricing_info[:sale_price_quantity]
      unit_quantity = quantity % pricing_info[:sale_price_quantity]
      (sale_quantity * pricing_info[:sale_price] + unit_quantity * pricing_info[:unit_price]).round(2)
    else
      (quantity * pricing_info[:unit_price]).round(2)
    end
  end

  def calculate_saved_amount
    @item_counts.sum do |item, quantity|
      pricing_info = PRICING_TABLE[item]
      next 0.0 unless pricing_info[:sale_price_quantity] && pricing_info[:sale_price]

      (quantity / pricing_info[:sale_price_quantity]) * (pricing_info[:unit_price] * pricing_info[:sale_price_quantity] - pricing_info[:sale_price])
    end.round(2)
  end
end

puts "Please enter all the items purchased separated by a comma"
items = gets.chomp.split(',').map(&:strip)

calculator = DiscountCalculator.new(items)
calculator.calculate_discount

