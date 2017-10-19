require './lib/markdown_converter_helper'
class MarkdownConverter
  include MarkdownConverterHelper

  attr_reader :input_filename
  def initialize(markdown)
    @input_filename = markdown
  end

  def input_data
    lines = File.readlines(input_filename)
    lines.map { |line| line.chomp }
  end

  def convert_markdown_to_html
    space_remove = ordered_list_format - [""]
    new_line_format = space_remove.map do |line|
      new_line_define(line)
    end.join
  end

  def ordered_list_format
    ordered_list_select.map do |element|
      ordered_list_tags(element)
    end.flatten
  end

  def ordered_list_select
    unordered_list_format.map do |str|
      ordered_item_replace(str)
    end.uniq
  end

  def unordered_list_format
    unordered_list_select.map do |element|
      unordered_list_tags(element)
    end.flatten
  end

  def unordered_list_select
    format_converter.map do |str|
      item_replace(str)
    end
  end

  def format_converter_split
    paragraph_converter.map do |str|
      split_format(str)
    end
  end

  def strong_convert
    format_converter_split.map do |element|
      strong_format(element)
    end
  end

  def emphasis_convert
    strong_convert.map do |element|
      emphasis_format(element)
    end
  end

  def format_converter
    emphasis_convert.map do |element|
      if element.is_a?(Array)
        element.join(" ")
      else
        element
      end
    end
  end

  def paragraph_converter
    convert_header.map do |str|
      format_paragraph(str)
    end
  end

  def convert_header
    input_data.map do |str|
      find_headers(str)
    end
  end
end
