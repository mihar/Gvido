pdf = Pdf.style(pdf)

pdf.text @invoice.student.to_s
pdf.text @invoice.payers_address
pdf.text @invoice.monthly_reference
pdf.text I18n.l @invoice.payment_date
pdf.text number_to_currency(@invoice.price)

