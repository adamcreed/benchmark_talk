require 'benchmark/ips'
require 'prime'

n = 345_676_543
range = 1..20

Benchmark.ips(10) do |x|
  x.config(time: 5, warmup: 2)

  x.report('for:') do
    a = []
    for i in range do
      a << n.prime?
    end
  end

  x.report('while:') do
    a = []
    a << n.prime? while a.length < range.max
  end

  x.report('until:') do
    a = []
    a << n.prime? until a.length >= range.max
  end

  x.report('loop:') do
    a = []
    loop do
      a << n.prime?
      break if a.length >= range.max
    end
  end

  x.report('times:') do
    a = []
    range.max.times do
      a << n.prime?
    end
  end

  x.report('upto:') do
    a = []
    1.upto range.max do
      a << n.prime?
    end
  end

  x.report('each:') do
    a = []
    range.each do
      a << n.prime?
    end
  end

  x.report('map:') do
    a = range.map do
      n.prime?
    end
  end

  x.report('recurse:') do
    def array_test(number, count, last, array)
      array << number.prime?
      array_test(number, count + 1, last, array) if count < last
    end

    a = []
    array_test n, range.min, range.max, a
  end
end
