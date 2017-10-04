require './lib/markdown_converter'
require './test/test_helper'

class ChiselTest < Minitest::Test
  def test_it_exists
    chisel = Chisel.new

    assert_instance_of Chisel, chisel
  end

  def test_that_file_input_works
    chisel = Chisel.new

    assert_equal "# My Life in Desserts\n", chisel.input_data.first
  end

  def test_that_one_line_can_be_converted
    chisel = Chisel.new
    # binding.pry
    assert_equal "<h1> My Life in Desserts </h1>", chisel.convert_single_line
  end

end
