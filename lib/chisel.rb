require './lib/markdown_converter'

markdown = ARGV[0]
html = ARGV[1]

input_data = File.read(markdown).chomp

converter = MarkdownConverter.new(markdown, html)

output = File.open(html, "w+")
output.write(converter.new_line_format_for_final_output)

puts "Converted #{markdown} (#{converter.input_data.length} lines) to #{ARGV[1]} (#{converter.new_line_format_for_final_output.length} lines)"
