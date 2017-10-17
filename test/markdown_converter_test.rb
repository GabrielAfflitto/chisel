require './lib/markdown_converter'
require './test/test_helper'

class MarkdownConverterTest < Minitest::Test
  attr_reader :converter
  def setup
    markdown = "my_input.md"
    html = "my_output.html"
    @converter = MarkdownConverter.new(markdown, html)
  end

  def test_it_exists
    assert_instance_of MarkdownConverter, converter
  end

  def test_that_file_input_works
    assert_equal "# My Life in Desserts", converter.input_data.first
  end

  def test_that_multiple_headers_can_be_converted
    assert_equal "<h1> My Life in Desserts </h1>", converter.convert_header[0]
    assert_equal "<h2> Chapter 1: The Beginning </h2>", converter.convert_header[2]
  end

  def test_paragraph_converter_works
    assert_equal "<p>\nHello, World.\n</p>", converter.paragraph_converter[4]
  end

  def test_format_converter_split_returns_all_strings_with_asterisk
    assert_equal ["<p>", "My", "*emphasized", "and", "**stronged**", "text*", "is", "awesome.", "</p>"], converter.format_converter_split[6]
  end

  def test_that_format_converter_can_convert_emphasized_and_strong_text
    assert_equal "<p> My <em>emphasized and <strong>stronged</strong> text</em> is awesome. </p>", converter.format_converter[6]
  end

  def test_that_strong_converter_can_convert_double_asterisks
    assert_equal ["<p>", "My", "*emphasized", "and", "<strong>stronged</strong>", "text*", "is", "awesome.", "</p>"], converter.strong_convert[6]
  end

  def test_that_emphasis_converter_can_convert_single_asterisks
    assert_equal ["<p>", "My", "<em>emphasized", "and", "<strong>stronged</strong>", "text</em>", "is", "awesome.", "</p>"], converter.emphasis_convert[6]
  end

  def test_unordered_list_select_returns_the_items_in_list_with_asterisks
    assert_equal ["* Sushi", "* Barbeque", "* Mexican"], converter.unordered_list_select[10]
  end

  def test_unordered_list_format_converts_list_to_proper_format
    skip
    assert_equal ["<ul>\n", "<li>Sushi</li>\n", "<li>Barbeque</li>\n", "<li>Mexican</li>\n", "</ul>\n"], converter.unordered_list_format
  end

  def test_list_select_returns_all_items_in_list_with_numbers
    assert_equal ["1. Sushi", "2. Barbeque", "3. Mexican"], converter.ordered_list_select[11]
  end

  def test_ordered_list_format_converts_numbered_list_to_proper_format
    skip
    assert_equal ["<ol>\n", "<li>Sushi</li>\n", "<li>Barbeque</li>\n", "<li>Mexican</li>\n", "</ol>\n"], converter.ordered_list_format
  end

end
