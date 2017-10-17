require 'pry'
require './lib/markdown_converter_helper'
class MarkdownConverter < MarkdownConverterHelper
  attr_reader :file_in, :file_out
  def initialize(markdown, html)
    @file_in = markdown
    @file_out = html
  end

  def input_data
    lines = File.readlines(file_in)
    lines.map { |line| line.chomp }
  end

  # def convert_header
  #   input_data.map do |str|
  #     if str.start_with?("#")
  #       hash_count = str.count "#"
  #       "<h#{hash_count}>" + str.delete("#") + " </h#{hash_count}>"
  #     else
  #       str
  #     end
  #   end
  # end
 # --------------
  # def format_headers(str)
  #   hash_count = str.count "#"
  #   "<h#{hash_count}>" + str.delete("#") + " </h#{hash_count}>"
  # end
  #
  # def find_headers(str)
  #   if str.start_with?("#")
  #     format_headers(str)
  #   else
  #     str
  #   end
  # end

  def convert_header
    input_data.map do |str|
      find_headers(str)
    end
  end
 # ----------------------

  def format_paragraph(str)
    if !str.empty? && !str.start_with?("<h") && str[1] != " " && str[1] != "."
      "<p>\n" + str + "\n</p>"
    else
      str
    end
  end

  def paragraph_converter
    convert_header.map do |str|
      format_paragraph(str)
    end
  end
  # def paragraph_converter
  #   convert_header.map do |str|
  #     if !str.empty? && !str.start_with?("<h") && str[1] != " " && str[1] != "."
  #       "<p>\n" + str + "\n</p>"
  #     else
  #       str
  #     end
  #   end
  # end
  #--------------------------
  def format_converter
    emphasis_convert.map do |element|
      if element.is_a?(Array)
        element.join(" ")
      else
        element
      end
    end
  end
 # -------------------------------------------

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

 def emphasis_convert
   strong_convert.map do |element|
     emphasis_format(element)
   end
 end

  # def emphasis_convert
  #   strong_convert.map do |element|
  #     if element.is_a?(Array)
  #       element.map do |word|
  #         word[0] = "<em>" if word.start_with?("*")
  #         word[-1] = "</em>" if word.end_with?("*")
  #         word
  #       end
  #     else
  #       element
  #     end
  #   end
  # end
 #-------------------------------------------------
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

  def strong_convert
    format_converter_split.map do |element|
      strong_format(element)
    end
  end

  # def strong_convert
  #   format_converter_split.map do |element|
  #     if element.is_a?(Array)
  #       element.map do |word|
  #         word[0..1] = "<strong>" if word.start_with?("**")
  #         word[-2..-1] = "</strong>" if word.end_with?("**")
  #         word
  #       end
  #     else
  #       element
  #     end
  #   end
  # end
 #-------------------------------------------
  def split_format(str)
    if str.count("*") > 1
      str.split
    else
      str
    end
  end

  def format_converter_split
    paragraph_converter.map do |str|
      split_format(str)
    end
  end

  # def format_converter_split
  #   paragraph_converter.map do |str|
  #     if str.include?("*") && str.count("*") > 1
  #       str.split
  #     else
  #       str
  #     end
  #   end
  # end
 #--------------------------------------

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

 def unordered_list_select
   format_converter.map do |str|
     item_replace(str)
   end
 end

  # def unordered_list_select
  #   unordered_units = paragraph_converter.select {|str| str if str.include?("*") && str[1] == " "}
  #   format_converter.map do |str|
  #     if str.include?("*")
  #       unordered_units
  #     else
  #       str
  #     end
  #   end.uniq
  # end

  def unordered_list_tags(element)
    if element.is_a?(Array)
      list_tags = element.map {|str| "<li>" + str.delete("* ") + "</li>"}
      list_push("<ul>", "</ul>", list_tags)
    else
      element
    end
  end

  def unordered_list_format
    unordered_list_select.map do |element|
      unordered_list_tags(element)
    end.flatten
  end

  # def unordered_list_format
  #   unordered_list_select.map do |element|
  #     if element.is_a?(Array)
  #       list_tags = element.map {|str| "<li>" + str.delete("* ") + "</li>"}
  #       list_push("<ul>", "</ul>", list_tags)
  #     else
  #       element
  #     end
  #   end.flatten
  # end
# -------------------------

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

  def ordered_list_select
    unordered_list_format.map do |str|
      ordered_item_replace(str)
    end.uniq
  end

  # def ordered_list_select
  #   ordered_units = paragraph_converter.select {|str| str if str[1] == "."}
  #   unordered_list_format.map do |str|
  #     if str[1] == "."
  #       ordered_units
  #     else
  #       str
  #     end
  #   end.uniq
  # end



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

  def ordered_list_format
    ordered_list_select.map do |element|
      ordered_list_tags(element)
    end.flatten
  end

  # def ordered_list_format
  #   ordered_list_select.map do |element|
  #     if element.is_a?(Array)
  #       list_tags = element.map do |str|
  #         str[0..2] = "<li>" if str[1] == "."
  #         str << "</li>"
  #       end
  #       list_push("<ol>", "</ol>", list_tags)
  #     else
  #       element
  #     end
  #   end.flatten
  # end

# ----------------------------

def new_line_define(line)
  if !line.end_with?("</li>") && !line.include?("<ul>") && !line.include?("<ol>")
    line + "\n\n"
  else
    line + "\n"
  end
end

def new_line_format_for_final_output
  space_remove = ordered_list_format - [""]
  new_line_format = space_remove.map do |line|
    new_line_define(line)
  end.join
end


  # def new_line_format_for_file
  #   space_remove = ordered_list_format - [""]
  #   new_line_format = space_remove.map do |line|
  #     if !line.end_with?("</li>") && !line.include?("<ul>") && !line.include?("<ol>")
  #       line + "\n\n"
  #     else
  #       line + "\n"
  #     end
  #   end.join
  # end
  # -------------------------------

  def list_push(open_tag, close_tag, list_tags)
    list_tags.unshift(open_tag)
    list_tags.push(close_tag)
  end

end
