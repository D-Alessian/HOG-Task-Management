module ApplicationHelper
  def gen_link(script)
    return "https://www.github.com/Nomi-CEu/Nomi-CEu/blob/main/overrides/#{script.path}#{script.name}"
  end

  def colorBoolean(script, attr)
    if script[attr]
      color = "green"
    else
      color = "red"
    end
    return "<a style=\"color: #{color};\">#{script[attr]}</a>"
  end
end
