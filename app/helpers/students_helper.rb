module StudentsHelper
  def net_ammount(total_price, discount)
    discount > 0 ? total_price - total_price * discount : total_price
  end
end

