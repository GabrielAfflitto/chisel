require './lib/markdown_converter'

class MarkdownConverterHelper
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
end
