#!/bin/env ruby
# Running this will create css which you can then put in your browser to add
# nice background colors to trello cards based on the labels


class TrelloColors

  GRADIENT_PADDING = 20

  LIGHTNESS = 85 # for light layout
  DARKNESS = 15 # for dark background layout

  def initialize(dark, platform)
    @dark_background = dark
    @platform = platform
  end

  def colors
    %w[purple green yellow orange blue red]
  end

  def plus_sl(hue)
    "hsl(#{hue}, 100%, #{@dark_background ? DARKNESS : LIGHTNESS}%)"
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

  def background(file, index)
    file.puts "div.list-card.#{colors[index]}-label {"
    file.puts "    background: #{color_value index} !important;"
    file.puts "}"
  end

  def span(color_index, start, fin)
    "#{color_value color_index} #{start}%, #{color_value color_index} #{fin}%"
  end

  def gradient(file, *indices)
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
    file.puts "div.list-card.#{classes.join('.')} {"
    file.puts "    background-image: -#{@platform}-linear-gradient(left, #{spec}) !important;"
    file.puts "}"

  end

  def rest(array,start=0)
    array[start..-1].each_index do |index|
      yield index + start
    end
  end

  def create_styles(file)
    rest colors, 0 do |i|
      background(file, i)
      rest colors, i+1 do |i2|
        gradient(file, i, i2)
        rest colors, i2+1 do |i3|
          gradient(file, i, i2, i3)
          rest colors, i3+1 do |i4|
            gradient(file, i, i2, i3, i4)
            rest colors, i4+1 do |i5|
              gradient(file, i, i2, i3, i4, i5)
              rest colors, i5+1 do |i6|
                gradient(file, i, i2, i3, i4, i5, i6)
              end
            end
          end
        end
      end
    end
  end

  def filename
    "#{@platform}-#{@dark_background ? 'dark' : 'light'}-background.css"
  end

  def run(filename)
    File.open(filename, 'w') do |f|
      if @dark_background
        f.puts <<-EOS.gsub('              ','')
              .list-card {
                  background: black !important;
                  color: white !important;
              }
              .list-card-title {
                  color: #EEE !important;
              }
              EOS
      end

      create_styles f

      f.puts <<-EOS.gsub('            ','')
            .card-labels {
                display: none !important;
            }
            EOS
    end
  end
end


if __FILE__ == $0
  dark = false # if true, the background will be dark
  platform = 'moz'
  all = false

  ARGV.each do |arg|
    case arg
    when 'light'
      dark = false
    when 'dark'
      dark = true
    when 'moz'
      platform = 'moz'
    when 'webkit'
      platform = 'webkit'
    when 'all'
      all = true
    end
  end

  unless all
    t = TrelloColors.new(dark, platform)
    t.run t.filename
  else
    t = TrelloColors.new(false, 'moz')
    t.run t.filename
    t = TrelloColors.new(true, 'moz')
    t.run t.filename
    t = TrelloColors.new(false, 'webkit')
    t.run t.filename
    t = TrelloColors.new(true, 'webkit')
    t.run t.filename
  end
end
