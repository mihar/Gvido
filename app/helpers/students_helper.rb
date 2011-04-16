module StudentsHelper
  def net_ammount(total_price, discount)
    discount > 0 ? total_price - total_price * discount : total_price
  end
  
  def payment_type(value)
    case value
      when 1 then return "Navadno plačilo"
      when 2 then return "Odšteta polovica kavcije"
      when 3 then return "Odšteta celotna kavcija"
      when 4 then return "Kavcija"
      when 5 then return "Vpisnina"
    end
  end
end

