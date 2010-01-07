# encoding: utf-8

# page_geometry.rb : Describes PDF page geometries
#
# Copyright April 2008, Gregory Brown.  All Rights Reserved.
#
# This is free software. Please see the LICENSE and COPYING files for details.

module Prawn
  class Document
    
    # Dimensions pulled from PDF::Writer, rubyforge.org/projects/ruby-pdf
    # 
    # All of these dimensions are in PDF Points, see Prawn::Measurements for
    # conversion utilities.
    # 
    # Additionally, if the size you are after is not listed below, you can always
    # specify your size by passing an array of width and height to Prawn::Document.new
    # like:
    # 
    #  Prawn::Document.new(:page_size => [1000, 20000])
    #
    # The sizes below can be used by passing the appropriate string to :size:
    # 
    #  Prawn::Document.new(:page_size => '2A0')
    # 
    # ===Inbuilt Sizes:
    # 
    # 
    # 4A0:: => 4767.87 x 6740.79
    # 2A0:: => 3370.39 x 4767.87
    # A0:: => 2383.94 x 3370.39
    # A1:: => 1683.78 x 2383.94
    # A2:: => 1190.55 x 1683.78
    # A3:: => 841.89 x 1190.55
    # A4:: => 595.28 x 841.89
    # A5:: => 419.53 x 595.28
    # A6:: => 297.64 x 419.53
    # A7:: => 209.76 x 297.64
    # A8:: => 147.40 x 209.76
    # A9:: => 104.88 x 147.40
    # A10:: => 73.70 x 104.88
    # B0:: => 2834.65 x 4008.19
    # B1:: => 2004.09 x 2834.65
    # B2:: => 1417.32 x 2004.09
    # B3:: => 1000.63 x 1417.32
    # B4:: => 708.66 x 1000.63
    # B5:: => 498.90 x 708.66
    # B6:: => 354.33 x 498.90
    # B7:: => 249.45 x 354.33
    # B8:: => 175.75 x 249.45
    # B9:: => 124.72 x 175.75
    # B10:: => 87.87 x 124.72
    # C0:: => 2599.37 x 3676.54
    # C1:: => 1836.85 x 2599.37
    # C2:: => 1298.27 x 1836.85
    # C3:: => 918.43 x 1298.27
    # C4:: => 649.13 x 918.43
    # C5:: => 459.21 x 649.13
    # C6:: => 323.15 x 459.21
    # C7:: => 229.61 x 323.15
    # C8:: => 161.57 x 229.61
    # C9:: => 113.39 x 161.57
    # C10:: => 79.37 x 113.39
    # RA0:: => 2437.80 x 3458.27
    # RA1:: => 1729.13 x 2437.80
    # RA2:: => 1218.90 x 1729.13
    # RA3:: => 864.57 x 1218.90
    # RA4:: => 609.45 x 864.57
    # SRA0:: => 2551.18 x 3628.35
    # SRA1:: => 1814.17 x 2551.18
    # SRA2:: => 1275.59 x 1814.17
    # SRA3:: => 907.09 x 1275.59
    # SRA4:: => 637.80 x 907.09
    # EXECUTIVE:: => 521.86 x 756.00
    # FOLIO:: => 612.00 x 936.00
    # LEGAL:: => 612.00 x 1008.00
    # LETTER:: => 612.00 x 792.00
    # TABLOID:: => 792.00 x 1224.00 
    #
    module PageGeometry

      SIZES = { "4A0" => [4767.87, 6740.79],
                "2A0" => [3370.39, 4767.87],
                 "A0" => [2383.94, 3370.39],
                 "A1" => [1683.78, 2383.94],
                 "A2" => [1190.55, 1683.78],
                 "A3" => [841.89, 1190.55],
                 "A4" => [595.28, 841.89],
                 "A5" => [419.53, 595.28],
                 "A6" => [297.64, 419.53],
                 "A7" => [209.76, 297.64],
                 "A8" => [147.40, 209.76],
                 "A9" => [104.88, 147.40],
                "A10" => [73.70, 104.88],
                 "B0" => [2834.65, 4008.19],
                 "B1" => [2004.09, 2834.65],
                 "B2" => [1417.32, 2004.09],
                 "B3" => [1000.63, 1417.32],
                 "B4" => [708.66, 1000.63],
                 "B5" => [498.90, 708.66],
                 "B6" => [354.33, 498.90],
                 "B7" => [249.45, 354.33],
                 "B8" => [175.75, 249.45],
                 "B9" => [124.72, 175.75],
                "B10" => [87.87, 124.72],
                 "C0" => [2599.37, 3676.54],
                 "C1" => [1836.85, 2599.37],
                 "C2" => [1298.27, 1836.85],
                 "C3" => [918.43, 1298.27],
                 "C4" => [649.13, 918.43],
                 "C5" => [459.21, 649.13],
                 "C6" => [323.15, 459.21],
                 "C7" => [229.61, 323.15],
                 "C8" => [161.57, 229.61],
                 "C9" => [113.39, 161.57],
                "C10" => [79.37, 113.39],
                "RA0" => [2437.80, 3458.27],
                "RA1" => [1729.13, 2437.80],
                "RA2" => [1218.90, 1729.13],
                "RA3" => [864.57, 1218.90],
                "RA4" => [609.45, 864.57],
               "SRA0" => [2551.18, 3628.35],
               "SRA1" => [1814.17, 2551.18],
               "SRA2" => [1275.59, 1814.17],
               "SRA3" => [907.09, 1275.59],
               "SRA4" => [637.80, 907.09],
          "EXECUTIVE" => [521.86, 756.00],
              "FOLIO" => [612.00, 936.00],
              "LEGAL" => [612.00, 1008.00],
             "LETTER" => [612.00, 792.00],
            "TABLOID" => [792.00, 1224.00] }


      # Returns the width and height of the current page in PDF points.
      # Usually, you'll want the dimensions of the bounding_box or 
      # margin_box instead.
      #
      def page_dimensions
        coords = SIZES[page_size] || page_size
        [0,0] + case(page_layout)
        when :portrait
          coords
        when :landscape
          coords.reverse
        else
          raise Prawn::Errors::InvalidPageLayout,
            "Layout must be either :portrait or :landscape"
        end
      end
    end
  end
end
