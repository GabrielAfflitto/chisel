require 'pry'


class MarkdownConverter

  attr_reader :file_in, :file_out

  def initialize(markdown, html)
    @file_in = markdown
    @file_out = html
  end

  # input_data = File.read(@file_in).chomp
  #
  # convert = MarkdownConverter.new(input_data)
  #
  # output = File.open(@file_out, "w+")
  # output.write(convert.convert_to_html)
  #
  # puts "Converted #{ARGV[1]} (#{convert.input_data.lines.length} lines) to #{ARGV[2]} (#{convert.output.length} lines)"

  def input_data
    # parent method for the rest of the converter class, get rid of
    # all variables in methods that are not needed and only used
    # for experimenting in pry
    lines = File.readlines(file_in)
    b = lines.map { |line| line.chomp }
  end

  def convert_header
    hash_count = input_data.map do |str|
      if str.start_with?("#")
        c = str.count "#"
        "<h#{c}>" + str.delete("#") + " </h#{c}>"
      end
    end
  end

  def paragraph_converter
    input_data.map do |str|
      if str.empty? == false && !str.start_with?("#") && str[1] != " "
        "<p>\n" + str + "\n</p>"
      else
        str
      end
    end
  end

  def format_converter
    emphasis_convert.join(" ")
  end

  def strong_convert
    # third and final method for the conversion of strong and emphasis
    format_converter_split.map do |word|
      word[0..1] = "<strong>" if word.start_with?("**")
      word[-2..-1] = "</strong>" if word.end_with?("**")
      word
    end
  end

  def emphasis_convert
    # second method
    strong_convert.map do |word|
      word[0] = "<em>" if word.start_with?("*")
      word[-1] = "</em>" if word.end_with?("*")
      word
    end
  end

  def format_converter_split
    # first method for strong and emphasis converter -uses parent
    # method paragraph_converter
    b = paragraph_converter.select {|str| str if str.include?("*") && str[1] != " "}.join.split
  end

  def list_select_asterisk
    paragraph_converter.select {|str| str if str.include?("*") && str[1] == " "}
  end

  def list_format
    front_format = list_select_asterisk.unshift("<ol>\n")
    back_format = front_format.push("</ol>\n")
    b = back_format.map do |item|
      if item.start_with?("*")
        "<li>" + item.delete("* ") + "</li>\n"
      else
        item
      end
    end
    binding.pry
  end

end
