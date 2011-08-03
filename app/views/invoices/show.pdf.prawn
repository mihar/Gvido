pdf = Pdf.style(pdf)
pdf = Pdf::Invoice.address_box(pdf, @invoice.student.to_s, @invoice.payers_address)
#pdf = Pdf::Invoice.logo_box(pdf)
pdf = Pdf::Invoice.invoice_box(pdf, I18n.l(@invoice.payment_date), @invoice.payers_name, @invoice.payers_address, @invoice.recievers_name, @invoice.recievers_address, @invoice.monthly_reference)
