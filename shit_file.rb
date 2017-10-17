def input_data
  lines = File.readlines(file_in)
  lines.map { |line| line.chomp }
end

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

def convert_header
  input_data.map do |str|
    find_headers(str)
  end
end

def is_header?(str)
  str.start_with?("<h")
end

def is_unordered_list?(str)
  str[1] = " "
end

def is_ordered?(str)
  str[1] = "."
end

def is_paragraph?(str)
  false if str.empty? or is_header?(str) or is_unordered_list?(str) or is_ordered_list?(str)
end
<!-- ------ -->
def split_format(str)
  if str.include?("*") && str.count("*") > 1
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

<!-- --------- -->

def strong_array(word)
  element.map do |word|
    word[0..1] = "<strong>" if word.start_with?("**")
    word[-2..-1] = "</strong>" if word.end_with?("**")
    word
  end
end

def strong_format(element)
  if element.is_a?(Array)
    strong_array(word)
  else
    element
  end
end

def strong_convert
  format_converter_split.map do |element|
    strong_format(element)
  end
end
<!-- ----------------- -->


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
# -------------------------

def item_replace(str)
  if str.include?("*")
    unordered_units
  else
    str
  end
end

def unordered_units
  paragraph_converter.select {|str| str if str.include?("*") && str[1] == " "}
end

def unordered_list_select
  format_converter.map do |str|
    item_replace(str)
  end.uniq
end
# ----------------------

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
    list_tag_format(element)
  end.flatten
end

# ---------------------

def ordered_list_tags(str)
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
    ordered_list_tags(str)
  end.uniq
end
# ------------------------------------

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
