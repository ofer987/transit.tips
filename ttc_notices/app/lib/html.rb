module Html
  def self.replace_non_breaking_space(original)
    new = ''
    original.to_s.each_char do |c|
      if c.codepoints.first == 160
        new += ' '
      else 
        new += c
      end
    end

    new
  end
end
