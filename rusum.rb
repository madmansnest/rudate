#!/usr/bin/env ruby
def rubles(rub, kop)
  rub_word = if rub%10==1 && (rub%100)/10!=1
    'рубль'
  elsif rub%10>=2 && rub%10<=4 && (rub%100)/10!=1
    'рубля'
  else
    'рублей'
  end
  kop_word = if kop%10==1 && (kop%100)/10!=1
    'копейка'
  elsif kop%10>=2 && kop%10<=4 && (kop%100)/10!=1
    'копейки'
  else
    'копеек'
  end
  rub_amount = `echo #{rub} | runum -m`.chomp
  kop_amount = `echo #{kop} | runum`.chomp
  "#{rub},#{format('%02d',kop)}₽ (#{rub_amount} #{rub_word} #{kop_amount} #{kop_word})"
end

def yuan(y, j, f)
  y_word = if y%10==1 && (y%100)/10!=1
    'юань'
  elsif y%10>=2 && y%10<=4 && (y%100)/10!=1
    'юаня'
  else
    'юаней'
  end
  f_word = if f%10==1 && (f%100)/10!=1 # the variable name should not be taken out of context
    'фэнь'
  elsif f%10>=2 && f%10<=4 && (f%100)/10!=1
    'фэня'
  else
    'фэней'
  end
  y_amount = `echo #{y} | runum -m`.chomp
  j_amount = `echo #{j} | runum -m`.chomp
  f_amount = `echo #{f} | runum -m`.chomp
  "¥#{y},#{j}#{f} (#{y_amount} #{y_word} #{j_amount} цзяо #{f_amount} #{f_word})"
end

if __FILE__ == $0
  tool_name = 'rusum'
  tool_usage = %Q{
  \e[1m#{tool_name}\e[0m

  a filter that replaces sums like 1234.56RUB or 7890.12CNY to words in russian

  Uses runum.

  }
  tool_version = File.mtime($0).strftime('%Y%m%d%H%M')

  gender = :f

  case ARGV.first
  when '-h'
    STDERR.puts tool_usage; exit 1
  when '-V'
    STDERR.puts "#{tool_name} version #{tool_version}"; exit 1
  end
  
  begin
  ARGF.each_line do |line|
      puts line.gsub(/(\d+)\.(\d{2})RUB/) { |m| rubles($1.to_i, $2.to_i)}
        .gsub(/(\d+)\.(\d)(\d)CNY/) { |m| yuan($1.to_i, $2.to_i, $3.to_i)}
  end
  rescue => e
    STDERR.puts e; exit 2
  end
end

