module ApplicationHelper
  def gen_link(script)
    return "https://www.github.com/Nomi-CEu/Nomi-CEu/blob/main/overrides/#{script.path}#{script.name}"
  end
end
