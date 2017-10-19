require './lib/markdown_converter'

markdown = ARGV[0]
html = ARGV[1]

converter = MarkdownConverter.new(markdown)

output = File.open(html, "w+")
output.write(converter.convert_markdown_to_html)

puts "Converted #{markdown} (#{converter.input_data.length} lines) to #{ARGV[1]} (#{converter.convert_markdown_to_html.length} lines)"
