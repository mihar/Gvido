# top padding = 4.5cm == 127.55pt
# left padding => 2cm == 56.69
# box size => 9cm x 4.5cm == 255.11pt x 127.55pt
def address_box(pdf, name, address)
  pdf.bounding_box  [0, pdf.bounds.absolute_top - 127.55], :width => 255.11, :height => 127.55 do
    pdf.move_down 5
    pdf.text name
    pdf.move_down 5
    pdf.text address
  end
  pdf  
end

def logo_box(pdf)
  pdf.bounding_box  [350, pdf.bounds.absolute_top - 127.55], :width => 255.11, :height => 127.55 do
    pdf.move_down 5
    pdf.text "Glasbena šola gvido"
  end
  pdf
end

def small_invoice_box(pdf, payment_date, payers_name, payers_address, recievers_name, recievers_address, monthly_reference)
  pdf.bounding_box  [10, pdf.cursor - 10], :width => 200, :height => 245.11 do
    pdf.text payers_name
    pdf.text payers_address
    pdf.text payment_date
    pdf.text monthly_reference
    pdf.text recievers_name
    pdf.text recievers_address
  end
  pdf
end

def big_invoice_box(pdf, payment_date, payers_name, payers_address, recievers_name, recievers_address, monthly_reference)
  pdf.bounding_box  [220, pdf.cursor + 245.11], :width => 200, :height => 245.11 do
    pdf.text payers_name
    pdf.text payers_address
    pdf.text payment_date
    pdf.text monthly_reference
    pdf.text recievers_name
    pdf.text recievers_address
  end
  pdf
end

def invoice_box(pdf, payment_date, payers_name, payers_address, recievers_name, recievers_address, monthly_reference)
  pdf.bounding_box  [0, pdf.bounds.absolute_bottom + 255], :width => 560, :height => 255 do
    pdf = small_invoice_box(pdf, payment_date, payers_name, payers_address, recievers_name, recievers_address, monthly_reference)
    pdf = big_invoice_box(pdf, payment_date, payers_name, payers_address, recievers_name, recievers_address, monthly_reference)
    pdf.stroke_bounds
  end
  pdf
end

pdf = Pdf.style(pdf)

pdf = address_box(pdf, @invoice.student.to_s, @invoice.payers_address)
pdf = logo_box(pdf)
pdf = invoice_box(pdf, I18n.l(@invoice.payment_date), @invoice.payers_name, @invoice.payers_address, @invoice.recievers_name, @invoice.recievers_address, @invoice.monthly_reference)

# 600.times do |x|
#   pdf.move_down 5
#   pdf.bounding_box  [x, pdf.cursor], :width => 200 do
#     pdf.move_down 5
#     pdf.text "#{x}"
#   end
#   pdf.start_new_page if x % 29 == 0
# end

# pdf.text @invoice.student.to_s
# pdf.text @invoice.payers_address
# pdf.text @invoice.monthly_reference
# pdf.text I18n.l @invoice.payment_date
# pdf.text number_to_currency(@invoice.price)

