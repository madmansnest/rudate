#!/usr/bin/env ruby
def day(d, cse)
  days = {
    1 => "первое",
    2 => "второе",
    3 => "третье",
    4 => "четвертое",
    5 => "пятое",
    6 => "шестое",
    7 => "седьмое",
    8 => "восьмое",
    9 => "девятое",
    10 => "десятое",
    11 => "одиннадцатое",
    12 => "двенадцатое",
    13 => "тринадцатое",
    14 => "четырнадцатое",
    15 => "пятнадцатое",
    16 => "шестнадцатое",
    17 => "семнадцатое",
    18 => "восемнадцатое",
    19 => "девятнадцатое",
    20 => "двадцатое",
  }
  out = case d
    when 1..20
      days[d]
    when 21..29
      "двадцать #{day(d - 20, cse)}"
    when 30
      "тридцатое"
    when 31
      "тридцать первое"
    else
      raise "Incorrect day: #{d}"
    end
  if cse == :gen
    out.gsub(/ое$/, "ого").gsub(/ье$/, "ьего")
  else
    out
  end
end

def month(m)
  months = [
    nil,
    "января",
    "февраля",
    "марта",
    "апреля",
    "мая",
    "июня",
    "июля",
    "августа",
    "сентября",
    "октября",
    "ноября",
    "декабря",
  ]
  case m
  when 1..12
    months[m]
  else
    raise "Incorrect month: #{m}"
  end
end

def year(y)
  out = []
  case y / 1000
  when 1
    out << "тысяча"
  when 2
    out << "две тысячи"
  else
    raise "Too far into the future"
  end
  out << [
    nil,
    "сто",
    "двести",
    "триста",
    "четыреста",
    "пятьсот",
    "шестьсот",
    "семьсот",
    "восемьсот",
    "девятьсот",
  ][y / 100 % 10]
  case y % 100
  when 1..20
    out << day(y % 100, :nom).gsub(/ое$/, "ый")
  when 21..99
    out << [
      nil,
      nil,
      "двадцать",
      "тридцать",
      "сорок",
      "пятьдесят",
      "шестьдесят",
      "семьдесят",
      "восемьдесят",
      "девяносто",
    ][y / 10 % 10]
    if y % 10 != 0
      out << day(y % 10, :gen)
    end
  end
  if out[-1] !~ /го$/
    out[-1].gsub!(/[оы]й$/, "")
    out[-1].gsub!(/^семь/, "семи")
    out[-1].gsub!(/^восемь/, "восьми")
    out[-1].gsub!(/о$/, "")
    out[-1] << "ого"
  end
  out.compact.join(" ")
end

public

def long_date(d, m, y, cse)
  "#{day(d, cse)} #{month(m)} #{year(y)} года"
end

def month_date(d, m, y, cse)
  "#{d} #{month(m)} #{y} г."
end

def numeric_date(d, m, y, cse)
  "#{format('%02d',d)}.#{format('%02d',m)}.#{y}"
end

if __FILE__ == $0
  tool_name = 'rudate'
  tool_usage = %Q{
  \e[1m#{tool_name}\e[0m

  a filter that replaces \e[3myyyy-mm-dd\e[0m with dates in russian

  default: long format
  \e[3mчетырнадцатое июля тысяча семьсот восемьдесят девятого года\e[0m

  -g: long format in genitive
  \e[3mчетырнадцатого июля тысяча семьсот восемьдесят девятого года\e[0m

  -m: medium format
  \e[3m14 июля 1789 г.\e[0m

  -n: numeric format
  \e[3m14.07.1789\e[0m
  }
  tool_version = File.mtime($0).strftime('%Y%m%d%H%M')

  cse = :nom
  fun = :long_date

  case ARGV.first
  when '-h'
    STDERR.puts tool_usage; exit 1
  when '-V'
    STDERR.puts "#{tool_name} version #{tool_version}"; exit 1
  when '-g'
    cse = :gen
    ARGV.shift
  when '-m'
    fun = :month_date
    ARGV.shift
  when '-n'
    fun = :numeric_date
    ARGV.shift
  end
  
  begin
  ARGF.each_line do |line|
    puts line.gsub(/(\d{4})-(\d{2})-(\d{2})/) { |m| fun.to_proc.call(nil, $3.to_i, $2.to_i, $1.to_i, cse) }
  end
  rescue => e
    STDERR.puts e; exit 2
  end
end
