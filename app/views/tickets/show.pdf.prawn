require 'prawn/format'
require 'prawn/layout'

#Prawn.debug = true

#pdf.header pdf.margin_box.top_left do
#  pdf.font "Helvetica" do
#    pdf.text "This is the header", :size => 10, :align => :right
#    pdf.stroke_horizontal_rule
#  end
#end

pdf.font "/usr/local/lib/ruby/gems/1.8/gems/prawn-core-0.8.4/data/fonts/tahoma.ttf"

pdf.footer [pdf.margin_box.left, pdf.margin_box.bottom + 10 + 50] do
#  pdf.stroke_horizontal_rule
#  pdf.text "#{@ticket.id} - TicketMule", :size => 9, :align => :right
  pdf.text "(เจ้าของงาน รับทราบ)ลงชื่อ.................................วันที่......................เวลา...................", :size => 11
  pdf.move_down(30)
  pdf.text "(หน่วยงานที่แจ้ง รับทราบผลการดำเนินงาน)ลงชื่อ.................................วันที่......................เวลา...................", :size => 11
  pdf.move_down(6)
  pdf.text "<b>ลงชื่อผู้ดำเนินการ</b>........................................<b>วันที่ดำเนินการ</b>....................................<b>เวลา</b>...........................", :size => 11

end

pdf.bounding_box([pdf.bounds.left, pdf.bounds.top],:width  => pdf.bounds.width, :height => pdf.bounds.height - 50) do
  pdf.text "เลขที่หนังสือ #{@ticket.id}", :size => 9, :align => :right
  pdf.move_down(16)
  pdf.text "<b>บันทึกส่ง(ซ่อม)ครุภัณฑ์คอมพิวเตอร์</b>", :size => 16, :align => :center

  pdf.move_down(16)

  pdf.font_size(11) do
    pdf.text "<b>หัวข้อ:</b> #{@ticket.title}"

    pdf.move_down(2)
    # @ticket.closed? ? "<b>แจ้งซ่อมเมื่อ:</b> #{ to_datetime_th @ticket.closed_at}" : ""
    data = [["<b>ผู้ติดต่อ:</b> #{@ticket.contact.full_name}", "<b>เบอร์โทรติดต่อ:</b> #{@ticket.contact.office_phone}" ],
            ["<b>สร้างเมื่อ:</b> #{ to_datetime_th @ticket.created_at}", "<b>สร้างโดย:</b> #{@ticket.creator.first_name} #{@ticket.creator.last_name}"],
            ["<b>ลำดับความสำคัญ:</b> #{@ticket.priority.name}","<b>กลุ่มงาน:</b> #{@ticket.group.name}"],
            ["<b>สถานะ:</b> #{@ticket.status.name}","<b>เจ้าของ:</b> #{@ticket.owner.nil? ? 'Unassigned' : @ticket.owner.first_name + "  "+  @ticket.owner.last_name}"]]

    pdf.table data, :border_width => 0,
                    :font_size => 11,
                    :column_widths => { 0 => 270, 1 => 270 },
                    :position => :left,
                    :horizontal_padding => 0

    pdf.move_down(5)

    pdf.text "<b>รายละเอียด:</b>"
    pdf.move_down(2)
    pdf.text "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{@ticket.details}"

    unless @ticket.attachments.empty?
      pdf.move_down(10)
      pdf.text "<b>Attachments:</b>"
      @ticket.attachments.each_with_index do |a, i|
        pdf.text "#{i+1}. #{a.name} #{a.nice_file_size}"
      end
    end
  end
end

#pdf.font_size(9) do
#  pdf.number_pages "Page <page> of <total>", [pdf.bounds.right - 50, 0]
#end
