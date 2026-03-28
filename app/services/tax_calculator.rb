class TaxCalculator
  def self.calculate(subtotal, province_code)
    province = Province.find_by(code: province_code)

    if province
      gst = (subtotal * province.gst_rate).round(2)
      pst = (subtotal * province.pst_rate).round(2)
      hst = (subtotal * province.hst_rate).round(2)

      total_tax = if province.hst_rate > 0
                    hst
                  else
                    (gst + pst).round(2)
                  end

      {
        gst: gst,
        pst: pst,
        hst: hst,
        total_tax: total_tax,
        total: (subtotal + total_tax).round(2),
        tax_type: province.hst_rate > 0 ? 'HST' : 'GST+PST',
        rates: {
          gst: province.gst_rate,
          pst: province.pst_rate,
          hst: province.hst_rate
        }
      }
    else
      # Default to Manitoba rates if province not found
      calculate(subtotal, 'MB')
    end
  end

  def self.provinces
    Province.pluck(:code)
  end
end