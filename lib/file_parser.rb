require './lib/markdown_converter'


class Chisel
  attr_reader :file_in, :file_out, :runner_file

  def initialize
    @runner_file = ARGV[0]
    @file_in = ARGV[1]
    @file_out = ARGV[2]
  end

  input_data = File.read(file_in).chomp

  convert = MarkdownConverter.new(input_data)

  output = File.open(file_out, "w+")
  output.write(convert.convert_to_html)

  puts "Converted #{ARGV[1]} (#{convert.input_data.lines.length} lines) to #{ARGV[2]} (#{convert.output.length} lines)"

end
