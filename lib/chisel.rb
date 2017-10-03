class Chisel
  def initialize
    @sym = {"#"=>["<h1>", "</h1>"],
            "##"=>["<h2", "</h2>"],
            "###"=>["<h3>", "</h3>"],
            "####"=>["<h4", "</h4>"],
            "#####"=>["<h5>", "</h5>"],
            "######"=>["<h6", "</h6>"]
            }
  end

  def input_data
    lines = File.readlines('my_input.md')
    lines.each do |line|
      line
    end
  end

  def convert_single_line(line)
    array = @sym["#"]
    if line.include?("#")
      b = line.tr(line[0], '')
      array.first + b + array.last
    end
  end

end
