class Pdf
  VERTICAL_SPACER = 10
  DOUBLE_VERTICAL_SPACER = 20
  H1 = 25
  H2 = 20
  H3 = 15
  NORMAL_FONT_SIZE = 13
  SMALLER_FONT_SIZE = 10
  FONT = "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
  
  PN_FORMAT = "Stran <page> od <total>"
  PN_OPTIONS = {
    :at => [540 - 150, 0], 
    :width => 150, 
    :align => :right, 
    :page_filter => (1..7), 
    :start_count_at => 1,
    :color => "333300" 
  }
  
  module Invoice
    class << self
      # top padding = 4.5cm == 127.55pt
      # left padding => 2cm == 56.69
      # box size => 9cm x 4.5cm == 255.11pt x 127.55pt
      def address_box(pdf, name, address)
        pdf.bounding_box  [66, pdf.bounds.absolute_top - 127.55], :width => 255.11, :height => 127.55 do
          pdf.move_down 5
          pdf.text name
          pdf.move_down 5
          _address = address.split(", ")
          _address.size.times do |i|
            pdf.text _address[i]
            pdf.move_down 5
          end
        end
        pdf  
      end

      def logo_box(pdf)
        pdf.bounding_box  [350, pdf.bounds.absolute_top - 127.55], :width => 255.11, :height => 127.55 do
          pdf.image File.join Rails.root, "public", "images", "pdf_logo.png"
        end
        pdf
      end

      # ime placnika => od dna = 8,7 cm, od levega roba = 0,6 cm
      def small_invoice_box(pdf, price, purpose_and_date, payment_date, payers_name, payers_address, recievers_name, recievers_address, monthly_reference)
        pdf.bounding_box  [15, pdf.cursor], :width => 160, :height => 297.25714286 do
          #Ime placnika
          pdf.bounding_box [0, pdf.cursor - 23.314 ], :width => 160, :height => 25 do
            pdf.move_down 9
            pdf.stroke_bounds
            pdf.text payers_name
          end
          #Namen/Rok placila
          pdf.bounding_box [0, pdf.cursor - 8.742 ], :width => 160, :height => 25 do
            pdf.move_down 9
            pdf.stroke_bounds
            pdf.text purpose_and_date
          end
          #Znesek
          pdf.bounding_box [37.457, pdf.cursor - 10 ], :width => 122.542, :height => 13 do
            pdf.move_down 3
            pdf.stroke_bounds
            pdf.text price
          end
          #IBAN
          pdf.bounding_box [0, pdf.cursor - 8.742 ], :width => 160, :height => 45 do
            pdf.move_down 12
            pdf.stroke_bounds
            pdf.text ::Invoice::RECIEVERS_IBAN
          end
          #Referenca prejemnika
          pdf.bounding_box [0, pdf.cursor - 8.742 ], :width => 160, :height => 13 do
            pdf.move_down 3
            pdf.stroke_bounds
            pdf.text monthly_reference
          end
          #Ime prejemnika
          pdf.bounding_box [0, pdf.cursor - 8.742 ], :width => 160, :height => 25 do
            pdf.move_down 9
            pdf.stroke_bounds
            pdf.text recievers_name
          end
          pdf.stroke_bounds
        end
        pdf
      end

      def big_invoice_box(pdf, price, purpose_and_date, payment_date, payers_name, payers_address, recievers_name, recievers_address, monthly_reference)
        pdf.bounding_box  [185.07874016, pdf.cursor + 297.25714286], :width => 441.92125984, :height => 297.25714286 do
          #Ime in naslov placnika
          pdf.bounding_box [0, pdf.cursor - 57.285 ], :width => 290, :height => 25 do
            pdf.move_down 9
            pdf.stroke_bounds
            pdf.text payers_name + ", " + payers_address
          end
          #koda namena in namen
          #koda namena
          pdf.bounding_box [0, pdf.cursor - 10], :width => 43, :height => 13 do
            pdf.move_down 3
            pdf.stroke_bounds
            pdf.text ::Invoice::PAYERS_CODE
          end
          #namen
          pdf.bounding_box [50, pdf.cursor + 13], :width => 333, :height => 13 do
            pdf.move_down 3
            pdf.stroke_bounds
            pdf.text purpose_and_date
          end          
          #Znesek, datum placila in idbanke
          #Znesek
          pdf.bounding_box [25, pdf.cursor - 8.742 ], :width => 115, :height => 13 do
            pdf.move_down 3
            pdf.stroke_bounds
            pdf.text price
          end
          
          #Datum
          pdf.bounding_box [150, pdf.cursor + 13], :width => 87, :height => 13 do
            pdf.move_down 3
            pdf.stroke_bounds
            pdf.text payment_date
          end
          #BIC banke
          pdf.bounding_box [245, pdf.cursor + 13], :width => 115, :height => 13 do
            pdf.move_down 3
            pdf.stroke_bounds
            pdf.text ::Invoice::RECIEVERS_BIC
          end
          
          #IBAN
          pdf.bounding_box [0, pdf.cursor - 8.7], :width => 380, :height => 13 do
            pdf.move_down 3
            pdf.stroke_bounds
            pdf.text ::Invoice::RECIEVERS_IBAN
          end
          
          #Referenca
          pdf.bounding_box [0, pdf.cursor - 8.7], :width => 43, :height => 13 do
            pdf.move_down 3
            pdf.stroke_bounds
            pdf.text ::Invoice::RECIEVERS_REFERENCE
          end
          
          pdf.bounding_box [50, pdf.cursor + 13], :width => 333, :height => 13 do
            pdf.move_down 3
            pdf.stroke_bounds
            pdf.text monthly_reference
          end          
          
          #Ime prejemnika
          pdf.bounding_box [0, pdf.cursor - 8.742 ], :width => 380, :height => 25 do
            pdf.move_down 9
            pdf.stroke_bounds
            pdf.text ::Invoice::RECIEVERS_NAME + ", " + ::Invoice::RECIEVERS_ADDRESS + ", " + ::Invoice::RECIEVERS_POST_OFFICE_AND_CITY
          end
          
          # pdf.text payers_name
          # pdf.text payers_address
          # pdf.text payment_date
          # pdf.text monthly_reference
          # pdf.text recievers_name
          # pdf.text recievers_address
          # pdf.stroke_bounds
        end
        pdf
      end

      def invoice_box(pdf, price, purpose_and_date, payment_date, payers_name, payers_address, recievers_name, recievers_address, monthly_reference)
        pdf.font FONT, :size => SMALLER_FONT_SIZE
        pdf.bounding_box  [0, pdf.bounds.absolute_bottom + 297.25714286], :width => 612, :height => 289.13385827 do
          pdf = small_invoice_box(pdf, price, purpose_and_date, payment_date, payers_name, payers_address, recievers_name, recievers_address, monthly_reference)
          pdf = big_invoice_box(pdf, price, purpose_and_date, payment_date, payers_name, payers_address, recievers_name, recievers_address, monthly_reference)
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