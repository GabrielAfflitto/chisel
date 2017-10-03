require 'pry'
require './lib/chisel'
require 'minitest/autorun'
require 'minitest/pride'

class ChiselTest < Minitest::Test
  def test_it_exists
    chisel = Chisel.new

    assert_instance_of Chisel, chisel
  end

  def test_that_one_line_can_be_converted
    chisel = Chisel.new

    assert_equal "<h1> My life in Desserts</h1>", chisel.convert_single_line("# My life in Desserts")
  end

  def test_that_argv_works
    chisel = Chisel.new

    assert_equal "# My Life in Desserts\n", chisel.input_data.first
  end

end
