#!/bin/env ruby
# Running this will create css which you can then put in your browser to add
# nice background colors to trello cards based on the labels

DARK_BACKGROUND = false # if true, the background will be dark
PLATFORM = 'moz'

ARGV.each do |arg|
  case arg
  when 'light':
      DARK_BACKGROUND = false
  when 'dark':
      DARK_BACKGROUND = true
  when 'moz':
      PLATFORM = 'moz'
  when 'webkit':
      PLATFORM = 'webkit'
  end
end

GRADIENT_PADDING = 20

LIGHTNESS = 90 # for light layout
DARKNESS = 15 # for dark background layout

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

def background(colors, index)
  puts "div.list-card.#{colors[index]}-label {"
  puts "    background: #{color_value index} !important;"
  puts "}"
end

def span(color_index, start, fin)
  "#{color_value color_index} #{start}%, #{color_value color_index} #{fin}%"
end

def gradient(colors, *indices)
  classes = indices.map{|i| "#{colors[i]}-label"}
  sum = 100 - (indices.size-1)*GRADIENT_PADDING
  length = sum/indices.size
  start = 0
  spans = indices.map do |c|
    s = span c, start, start+length
    start = start+length+GRADIENT_PADDING
    s
  end
  spec = spans.join(', ')
  puts "div.list-card.#{classes.join('.')} {"
  puts "    background-image: -#{PLATFORM}-linear-gradient(to right, #{spec}) !important;"
  puts "}"

end

def rest(array,start=0)
  array[start..-1].each_index do |index|
    yield index + start
  end
end

def create_styles(colors)
  rest colors, 0 do |i|
    background(colors, i)
    rest colors, i+1 do |i2|
      gradient(colors, i, i2)
      rest colors, i2+1 do |i3|
        gradient(colors, i, i2, i3)
        rest colors, i3+1 do |i4|
          gradient(colors, i, i2, i3, i4)
          rest colors, i4+1 do |i5|
            gradient(colors, i, i2, i3, i4, i5)
            rest colors, i5+1 do |i6|
              gradient(colors, i, i2, i3, i4, i5, i6)
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
.list-card-title {
    color: #EEE !important;
}
EOS
end

create_styles colors

puts <<EOS
.card-labels {
    display: none !important;
}
EOS
