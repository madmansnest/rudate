#!/usr/bin/env ruby
def ones(n, gender)
  case n
  when 0
    ''
  when 1
    if gender==:f
      'одна'
    elsif gender==:n
      'одно'
    else
      'один'
    end
  when 2
    if gender==:f
      'две'
    else
      'два'
    end
  when 3
    'три'
  when 4
    'четыре'
  when 5
    'пять'
  when 6
    'шесть'
  when 7
    'семь'
  when 8
    'восемь'
  when 9
    'девять'
  when 10
    'десять'
  when 11
    'одиннадцать'
  when 12
    'двенадцать'
  when 13
    'тринадцать'
  when 14
    'четырнадцать'
  when 15
    'пятнадцать'
  when 16
    'шестнадцать'
  when 17
    'семнадцать'
  when 18
    'восемнадцать'
  when 19
    'девятнадцать'
  else
    raise "ones() called with improper value: #{n}"
  end
end

def tens(n, gender)
  case n
  when 0..19
    ones(n, gender)
  when 20..99
    out = case n/10
    when 2
      'двадцать'
    when 3
      'тридцать'
    when 4
      'сорок'
    when 5
      'пятьдесят'
    when 6
      'шестьдесят'
    when 7
      'семьдесят'
    when 8
      'восемьдесят'
    when 9
      'девяносто'
    end
    unless n%10==0
      out << ' ' << ones(n%10, gender) 
    end
    out
  else
    raise "tens() called with improper value: #{n}"
  end
end

def hundreds(n, gender)
  case n
  when 0..99
    tens(n, gender)
  when 100..999
    out = case n/100
    when 1
      'сто'
    when 2
      'двести'
    when 3
      'триста'
    when 4
      'четыреста'
    when 5
      'пятьсот'
    when 6
      'шестьсот'
    when 7
      'семьсот'
    when 8
      'восемьсот'
    when 9
      'девятьсот'
    end
    unless n%100==0
      out << ' ' << tens(n%100, gender).to_s
    end
  else
    raise "hundreds() called with improper value: #{n}"
  end
end

def cls(i, nn)
  classes = [nil, nil, 'миллион', 'миллиард', 'триллион', 'квадриллион', 'квинтиллион', 'секстиллион', 'септиллион', 'октиллион', 'нониллион', 'дециллион', 'ундециллион', 'дуодециллион', 'тредециллион', 'кваттордециллион', 'квиндециллион', 'седециллион', 'септдециллион', 'дуодевигинтиллион', 'ундевигинтиллион', 'вигинтиллион']
  case i
  when 0 
    nil
  when 1
    if nn%10==1 && (nn%100)/10!=1
      'тысяча'
    elsif nn%10>=2 && nn%10<=4 && (nn%100)/10!=1
      'тысячи'
    else
      'тысяч'
    end
  else
    if nn%10==1 && (nn%100)/10!=1
      classes[i]
    elsif nn%10>=2 && nn%10<=4 && (nn%100)/10!=1
      "#{classes[i]}а"
    else
      "#{classes[i]}ов"
    end
  end
end

def number(n, gender)
  out = []
  i = 0
  while n/1000**i>0
    nn = n/1000**i % 1000
    case i
    when 0
    when 1
      gender=:f
    else
      gender=:m
    end
    out = [hundreds(nn, gender), cls(i, nn)].concat(out)
    i += 1
  end
  if out.size==0
    'нуль'
  else
    out.compact.join(' ')
  end
end

if __FILE__ == $0
  tool_name = 'runum'
  tool_usage = %Q{
  \e[1m#{tool_name}\e[0m

  a filter that replaces integers with numbers in russian

  default: feminine

  -m: masculine

  -n: neuter

  }
  tool_version = File.mtime($0).strftime('%Y%m%d%H%M')

  gender = :f

  case ARGV.first
  when '-h'
    STDERR.puts tool_usage; exit 1
  when '-V'
    STDERR.puts "#{tool_name} version #{tool_version}"; exit 1
  when '-m'
    gender = :m
    ARGV.shift
  when '-n'
    gender = :n
    ARGV.shift
  end
  
  begin
  ARGF.each_line do |line|
      puts line.gsub(/(\d+)/) { |m| number($1.to_i, gender)}
  end
  rescue => e
    STDERR.puts e; exit 2
  end
end

