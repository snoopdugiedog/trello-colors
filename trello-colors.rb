
# colors.each do |card|
#   colors.each do |label|
#     if (card == label)
#       puts <<EOS
# div.list-card.#{card}-label .card-label.#{label}-label {
#     display: none !important;
# }
# EOS
#     else
#       puts <<EOS
# div.list-card.#{card}-label .card-label.#{label}-label {
#     display: block !important;
# }
# EOS
#     end
#   end
# end

DARK_BACKGROUND = true # if true, the background will be dark
GRADIENT_PADDING = 15

LIGHTNESS = 90 # for light layout
DARKNESS = 20 # for dark background layout

def colors
  %w[purple green yellow orange blue red]
end

def plus_sl(hue)
  "hsl(#{hue}, 100%, #{DARK_BACKGROUND ? DARKNESS : LIGHTNESS}%)"
end
def color_value(index)
  case index
  when 0
    # 'plum'
    plus_sl 300
  when 1
    # 'paleGreen'
    plus_sl 120
  when 2
    # 'LightGoldenrodYellow'
    plus_sl 60
  when 3
    # 'orange'
    plus_sl 30
  when 4
    # 'lightBlue'
    plus_sl 240
  when 5
    # 'pink'
    plus_sl 0
  end
end

def selects(colors, start='div.list-card')
  colors.each_index do |index|
    puts "#{start}.#{colors[index]}-label {"
    puts "    background: #{color_value index} !important;"
    puts "}"
  end
end

def gradient(colors, spec, *indices)
  l = indices.map{|i| "#{colors[i]}-label"}
  puts "div.list-card.#{l.join('.')} {"
  puts "    background-image: -moz-linear-gradient(to right, #{spec}) !important;"
  puts "}"

end

def rest(array,start=0)
  array[start..-1].each_index do |index|
    yield index + start
  end
end

def span(color_index, start, fin)
  "#{color_value color_index} #{start}%, #{color_value color_index} #{fin}%"
end

def spec(*args)
  sum = 100 - (args.size-1)*GRADIENT_PADDING
  length = sum/args.size
  start = 0
  spans = args.map do |c|
    s = span c, start, start+length
    start = start+length+GRADIENT_PADDING
    s
  end
  spans.join(', ')
end

def selects_two(colors)
  rest colors, 0 do |i|
    rest colors, i+1 do |i2|
      gradient(colors, spec(i, i2), i, i2)
    end
  end
end

def selects_three(colors)
  rest colors, 0 do |i|
    rest colors, i+1 do |i2|
      rest colors, i2+1 do |i3|
        gradient(colors, spec(i, i2, i3),
                 i, i2, i3)
      end
    end
  end
end

def selects_four(colors)
  rest colors, 0 do |i|
    rest colors, i+1 do |i2|
      rest colors, i2+1 do |i3|
        rest colors, i3+1 do |i4|
          gradient(colors, spec(i, i2, i3, i4),
                   i, i2, i3, i4)
        end
      end
    end
  end
end

def selects_five(colors)
  rest colors, 0 do |i|
    rest colors, i+1 do |i2|
      rest colors, i2+1 do |i3|
        rest colors, i3+1 do |i4|
          rest colors, i4+1 do |i5|
            gradient(colors, spec(i, i2, i3, i4, i5),
                     i, i2, i3, i4, i5)
          end
        end
      end
    end
  end
end

def selects_six(colors)
  rest colors, 0 do |i|
    rest colors, i+1 do |i2|
      rest colors, i2+1 do |i3|
        rest colors, i3+1 do |i4|
          rest colors, i4+1 do |i5|
            rest colors, i5+1 do |i6|
              gradient(colors, spec(i, i2, i3, i4, i5, i6),
                       i, i2, i3, i4, i5, i6)
            end
          end
        end
      end
    end
  end
end

if DARK_BACKGROUND
  puts <<EOS
.list-card {
    background: black !important;
    color: white !important;
}
.list-card a {
    color: #EEE !important;
}
EOS
end

selects colors
puts '/* two colors */'
selects_two colors
puts '/* three colors */'
selects_three colors
puts '/* four colors */'
selects_four colors
puts '/* five colors */'
selects_five colors
puts '/* six colors */'
selects_six colors

puts <<EOS
.card-labels {
    display: none !important;
}
EOS
