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

  def test_find_headers_will_find_string_with_hash_symbol_and_convert_it_to_html
    str = "# My Life in Desserts"
    assert_equal "<h1> My Life in Desserts </h1>", converter.find_headers(str)
  end

  def test_that_multiple_headers_can_be_converted
    assert_equal "<h1> My Life in Desserts </h1>", converter.convert_header[0]
    assert_equal "<h2> Chapter 1: The Beginning </h2>", converter.convert_header[2]
  end

  def test_format_paragraph_will_change_format_of_string_that_meets_conditions
    str = "Hello, World."
    assert_equal "<p>\nHello, World.\n</p>", converter.format_paragraph(str)
  end

  def test_paragraph_converter_works
    assert_equal "<p>\nHello, World.\n</p>", converter.paragraph_converter[4]
  end

  def test_split_format_splits_string_with_more_than_one_asterisk
    str = "*hello world*"
    assert_equal ["*hello", "world*"], converter.split_format(str)
  end

  def test_format_converter_split_returns_all_strings_with_asterisk
    assert_equal ["<p>", "My", "*emphasized", "and", "**stronged**", "text*", "is", "awesome.", "</p>"], converter.format_converter_split[9]
  end

  def test_that_format_converter_can_convert_emphasized_and_strong_text
    assert_equal "<p> My <em>emphasized and <strong>stronged</strong> text</em> is awesome. </p>", converter.format_converter[9]
  end

  def test_strong_tags_will_reformat_tags_with_double_asterisks
    word = "**Reformat"
    assert_equal "<strong>Reformat", converter.strong_tags(word)

    word = "Reformat**"
    assert_equal "Reformat</strong>", converter.strong_tags(word)
  end

  def test_that_strong_converter_can_convert_double_asterisks
    assert_equal ["<p>", "My", "*emphasized", "and", "<strong>stronged</strong>", "text*", "is", "awesome.", "</p>"], converter.strong_convert[9]
  end

  def test_emphasis_tags_will_format_words_with_single_asterisks
    word = "*Hello"
    assert_equal "<em>Hello", converter.emphasis_tags(word)

    word = "World*"
    assert_equal "World</em>", converter.emphasis_tags(word)
  end

  def test_that_emphasis_converter_can_convert_single_asterisks
    assert_equal ["<p>", "My", "<em>emphasized", "and", "<strong>stronged</strong>", "text</em>", "is", "awesome.", "</p>"], converter.emphasis_convert[9]
  end

  def test_item_replace_converts_all_unordered_list_items_into_array
    str = "* hello"
    assert_equal ["* Sushi", "* Barbeque", "* Mexican"], converter.item_replace(str)
  end

  def test_unordered_list_select_returns_the_items_in_list_with_asterisks
    assert_equal ["* Sushi", "* Barbeque", "* Mexican"], converter.unordered_list_select[13]
  end

  def test_unordered_list_format_converts_list_to_proper_format
    refute converter.unordered_list_format.include?("<ul>\n")
    refute converter.unordered_list_format.include?("</ul>\n")
  end

  def test_ordered_item_replace_converts_all_ordered_list_items_into_array
    str = "1. Sushi"
    assert_equal ["1. Sushi", "2. Barbeque", "3. Mexican"], converter.ordered_item_replace(str)
  end

  def test_list_select_returns_all_items_in_list_with_numbers
    assert_equal ["1. Sushi", "2. Barbeque", "3. Mexican"], converter.ordered_list_select[13]
  end

  def test_ordered_list_format_converts_numbered_list_to_proper_format
    refute converter.ordered_list_format.include?("<ol>\n")
    refute converter.ordered_list_format.include?("</ul>\n")
  end

  def test_new_line_define_will_add_new_line_break_to_every_element_with_no_line_break
    line = "This is my line"
    assert_equal "This is my line\n\n", converter.new_line_define(line)

    line = "<li>This is my line</li>"
    assert_equal "<li>This is my line</li>\n", converter.new_line_define(line)
  end

end
