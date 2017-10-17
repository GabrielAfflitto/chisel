require './lib/markdown_converter'

module MarkdownConverterHelper
  def format_headers(str)
    hash_count = str.count "#"
    "<h#{hash_count}>" + str.delete("#") + " </h#{hash_count}>"
  end

  def find_headers(str)
    if str.start_with?("#")
      format_headers(str)
    else
      str
    end
  end

  def format_paragraph(str)
    if !str.empty? && !str.start_with?("<h") && str[1] != " " && str[1] != "."
      "<p>\n" + str.gsub("&", "&amp;") + "\n</p>"
    else
      str
    end
  end

  def emphasis_tags(word)
    word[0] = "<em>" if word.start_with?("*")
    word[-1] = "</em>" if word.end_with?("*")
    word
  end

  def emphasis_format(element)
    if element.is_a?(Array)
      element.map do |word|
        emphasis_tags(word)
      end
    else
      element
    end
  end

  def strong_tags(word)
    word[0..1] = "<strong>" if word.start_with?("**")
    word[-2..-1] = "</strong>" if word.end_with?("**")
    word
  end

  def strong_format(element)
    if element.is_a?(Array)
      element.map do |word|
        strong_tags(word)
      end
    else
      element
    end
  end

  def split_format(str)
    if str.count("*") > 1
      str.split
    else
      str
    end
  end

  def unordered_units
    paragraph_converter.select {|str| str if str.include?("*") && str[1] == " "}
  end

  def item_replace(str)
    if str.include?("*")
      unordered_units
    else
      str
    end
  end

  def unordered_list_tags(element)
    if element.is_a?(Array)
      list_tags = element.map {|str| "<li>" + str.delete("* ") + "</li>"}
      list_push("<ul>", "</ul>", list_tags)
    else
      element
    end
  end

  def ordered_item_replace(str)
    if str[1] == "."
      ordered_units
    else
      str
    end
  end

  def ordered_units
    paragraph_converter.select {|str| str if str[1] == "."}
  end

  def ordered_list_tags(element)
    if element.is_a?(Array)
      list_tags = element.map do |str|
        str[0..2] = "<li>" if str[1] == "."
        str << "</li>"
      end
      list_push("<ol>", "</ol>", list_tags)
    else
      element
    end
  end

  def new_line_define(line)
    if !line.end_with?("</li>") && !line.include?("<ul>") && !line.include?("<ol>")
      line + "\n\n"
    else
      line + "\n"
    end
  end
end
