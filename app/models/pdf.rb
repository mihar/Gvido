class Pdf
  VERTICAL_SPACER = 10
  H1 = 25
  H2 = 20
  H3 = 15
  NORMAL_FONT_SIZE = 10
  FONT = "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
  
  module Invoice
    class << self
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
    end
  end
  class << self
    def add_page_numbers(pdf)
      pdf.number_pages "Stran <page> od <total>", [pdf.bounds.right - 80, -20]
      pdf
    end
    
    def style(pdf)
      pdf.font FONT, :size => NORMAL_FONT_SIZE
      pdf
    end
    
    def image(pdf, resource, size = :medium, position = nil, vposition = nil)
      if resource.photos.any?
        if position and vposition
          pdf.image self.image_path(resource, size), :position => position, :vposition => vposition
        
        elsif position
          pdf.image self.image_path(resource, size), :position => position
          
        elsif vposition
          pdf.image self.image_path(resource, size), :vposition => vposition
        
        else
          pdf.image self.image_path(resource, size)
        end
        pdf.move_down VERTICAL_SPACER
      end
      pdf
    end
    
    def h1(pdf, text) self.style_and_move_down(pdf, text, :h1) end
    def h2(pdf, text) self.style_and_move_down(pdf, text, :h2) end
    def h3(pdf, text) self.style_and_move_down(pdf, text, :h3) end
    
    def style_and_move_down(pdf, text, style)
      case style
      when :h1 then pdf.text_box text, :align => :left, :width => 300, :size => H1
      when :h2 then pdf.text text, :size => H2
      when :h3 then pdf.text text, :size => H3
      end
      pdf.move_down VERTICAL_SPACER
      pdf
    end
    
  end
end