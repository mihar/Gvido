module TaxTypesHelper
  def format_percent(tax_type)
    return "#{tax_type.tax.to_f * 100} %"
  end
end
