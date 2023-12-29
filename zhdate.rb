#!/usr/bin/env ruby

# Function names are horrible because i could not think of a short enough
# description of what they do.

# Translates digits to Chinese characters.
def f1(n)
  n.to_s.tr("0123456789","〇一二三四五六七八九")
end

# Translates digits to Chinese characters and accounts for tens.
def f2(n)
  out = f1(n)
if out.chars.length==1
  out
else
out = out.chars.to_a
out.insert(1, "十")
    out.shift if out.first=="一"
    out.pop if out.last=="〇"
out.join('')
end
end

public

def long_date(d, m, y)
  "#{f1(y)}年#{f2(m)}月#{f2(d)}日"
end

def numeric_date(d, m, y)
  "#{y}年#{m}月#{d}日"
end

if __FILE__ == $0
  tool_name = 'zhdate'
  tool_usage = %Q{
  \e[1m#{tool_name}\e[0m

  a filter that replaces \e[3myyyy-mm-dd\e[0m with dates in chinese

  default: long format
  \e[3m一七八九年七月十四日\e[0m

  -n: numeric format
  \e[3m1789年7月14日\e[0m
  }
  tool_version = File.mtime($0).strftime('%Y%m%d%H%M')

  fun = :long_date

  case ARGV.first
  when '-h'
    STDERR.puts tool_usage; exit 1
  when '-V'
    STDERR.puts "#{tool_name} version #{tool_version}"; exit 1
  when '-n'
    fun = :numeric_date
    ARGV.shift
  end
  
  begin
  ARGF.each_line do |line|
    puts line.gsub(/(\d{4})-(\d{2})-(\d{2})/) { |m| fun.to_proc.call(nil, $3.to_i, $2.to_i, $1.to_i) }
  end
  rescue => e
    STDERR.puts e; exit 2
  end
end
