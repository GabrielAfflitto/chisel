class MarkdownConverter
  def input_data
    lines = File.readlines('my_input.md')
    lines.each do |line|
      line
    end
  end

  def convert_single_line
    b = input_data.first.split
    g = b.map{|x| x == "#"? "<h1>" : x}
    g.push("</h1>")
    g.join(" ")
  end

end
