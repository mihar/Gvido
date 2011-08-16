prawn_document(:renderer => ApplicationHelper::Override, :page_layout => :portrait, :layout => :a4, :margin => 0) do |pdf|
  pdf = Pdf.style(pdf)
  pdf = Pdf::Invoice.address_box(pdf, @invoice.student.to_s, @invoice.payers_address)
  pdf = Pdf::Invoice.logo_box(pdf)
  pdf = Pdf::Invoice.invoice_box(pdf, number_to_currency(@invoice.price), @invoice.purpose_and_date, I18n.l(@invoice.payment_date), @invoice.payers_name, @invoice.payers_address, @invoice.recievers_name, @invoice.recievers_address, @invoice.monthly_reference)
  
end
