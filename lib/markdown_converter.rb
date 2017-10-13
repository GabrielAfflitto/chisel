require 'pry'

class MarkdownConverter

  attr_reader :file_in, :file_out

  def initialize(markdown, html)
    @file_in = markdown
    @file_out = html
  end
  # output = File.open(@file_out, "w+")
  # output.write(convert.convert_to_html)
  #
  # puts "Converted #{ARGV[1]} (#{convert.input_data.lines.length} lines) to #{ARGV[2]} (#{convert.output.length} lines)"

  def convert_to_html
    convert_header
    paragraph_converter
    format_converter
    unordered_list_format
    ordered_list_format
    # binding.pry
  end

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
      else
        str
      end
    end
  end

  def paragraph_converter
    b = convert_header.map do |str|
      if !str.empty? && !str.start_with?("<h") && str[1] != " " && str[1] != "."
        "<p>\n" + str + "\n</p>"
      else
        str
      end
    end
  end

  def format_converter
    # fourth and final method for format converter
    # emphasis_convert.join(" ")
    f = emphasis_convert.map do |element|
      if element.is_a?(Array)
        element.join(" ")
      else
        element
      end
    end
  end

  def strong_convert
    # second method
    # format_converter_split.map do |word|
    #   word[0..1] = "<strong>" if word.start_with?("**")
    #   word[-2..-1] = "</strong>" if word.end_with?("**")
    #   word
    # end
    g = format_converter_split.map do |element|
      if element.is_a?(Array)
        element.map do |word|
          word[0..1] = "<strong>" if word.start_with?("**")
          word[-2..-1] = "</strong>" if word.end_with?("**")
          word
        end
      else
        element
      end
    end
    # binding.pry
  end

  def emphasis_convert
    # third method
    # g = strong_convert.map do |word|
    #   word[0] = "<em>" if word.start_with?("*")
    #   word[-1] = "</em>" if word.end_with?("*")
    #   word
    # end
    g = strong_convert.map do |element|
      if element.is_a?(Array)
        element.map do |word|
          word[0] = "<em>" if word.start_with?("*")
          word[-1] = "</em>" if word.end_with?("*")
          word
        end
      else
        element
      end
    end
    # binding.pry
  end

  def format_converter_split
    # first method for strong and emphasis converter -uses parent
    # method paragraph_converter
    # b = paragraph_converter.select {|str| str if str.include?("*") && str[1] != " "}.join.split
    g = paragraph_converter.map do |str|
      if str.include?("*") && str.count("*") > 1
        str.split
      else
        str
      end
    end
    # binding.pry
  end

  def unordered_list_select
    b = paragraph_converter.select {|str| str if str.include?("*") && str[1] == " "}
    #this method needs work
    # c = paragraph_converter.select {|str| str if str[1] == "."}
    g = format_converter.map do |str|
      if str.include?("*")
        b
      else
        str
      end
    end.uniq
    # binding.pry
  end

  def unordered_list_format
    # tried refactoring with single line if statement, does
    # not have same output
    # front_format = unordered_list_select.unshift("<ul>\n")
    # back_format = front_format.push("</ul>\n")
    # b = back_format.map do |item|
    #   if item.start_with?("*")
    #     "<li>" + item.delete("* ") + "</li>\n"
    #   else
    #     item
    #   end
    #   binding.pry
    # end
    g = unordered_list_select.map do |element|
      if element.is_a?(Array)
        f = element.map {|str| "<li>" + str.delete("* ") + "</li>\n"}
        f.unshift("<ul>\n")
        f.push("</ul>\n")
      else
        element
      end
    end.flatten
    # binding.pry
  end

  def ordered_list_select
    # this method needs work
    g = paragraph_converter.select {|str| str if str[1] == "."}
    v = unordered_list_format.map do |str|
      if str[1] == "."
        g
      else
        str
      end
    end.uniq
    # binding.pry
  end

  def ordered_list_format
    # seperate list tags to their own methods, also create tests for them
    # front_format = ordered_list_select.unshift("<ol>\n")
    # back_format = front_format.push("</ol>\n")
    # b = back_format.map do |item|
    #   item[0..2] = "<li>" if item[1] == "."
    #   item << "</li>\n" if item.start_with?("<li>")
    #   item
    # end
    c = ordered_list_select.map do |element|
      if element.is_a?(Array)
        f = element.map do |str|
          str[0..2] = "<li>" if str[1] == "."
          str << "</li>\n" if str.start_with?("<li>")
        end
        f.unshift("<ol>\n")
        f.push("</ol>\n")
      else
        element
      end
    end.flatten
    # binding.pry
  end

end
