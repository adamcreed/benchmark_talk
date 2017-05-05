require 'benchmark/ips'
require 'prime'

n = 345_676_543

Benchmark.ips(10) do |x|
  x.config(time: 1, warmup: 2)

  x.report('native:') do
    n.prime?
  end

  x.report('for:') do
    def prime?(number)
      return true if number == 2
      return false if number < 2 or number.even?
      loop_count = Math.sqrt(number).floor

      for num in (3..loop_count).step(2) do
        return false if (number % num).zero?
      end

      true
    end

    prime?(n)
  end

  x.report('while:') do
    def prime?(number)
      return true if number == 2
      return false if number == 1 or number.even?
      loop_count = Math.sqrt(number).floor
      num = 3

      while num <= loop_count
        return false if (number % num).zero?

        num += 2
      end

      true
    end

    prime?(n)
  end

  x.report('until:') do
    def prime?(number)
      return true if number == 2
      return false if number < 2 or number.even?
      loop_count = Math.sqrt(number).floor
      num = 3

      until num >= loop_count
        return false if (number % num).zero?

        num += 2
      end

      true
    end

    prime?(n)
  end

  x.report('loop:') do
    def prime?(number)
      return true if number == 2
      return false if number < 2 or number.even?
      loop_count = Math.sqrt(number).floor
      num = 3

      loop do
        break unless num <= loop_count
        return false if (number % num).zero?
        num += 2
      end

      true
    end

    prime?(n)
  end

  x.report('times:') do
    def prime?(number)
      return false if number < 2
      loop_count = Math.sqrt(number).floor

      loop_count.times do |num|
        return false if (number % (num + 2)).zero?
      end

      true
    end

    prime?(n)
  end

  x.report('upto:') do
    def prime?(number)
      return false if number < 2
      loop_count = Math.sqrt(number).floor

      2.upto(loop_count) do |num|
        return false if (number % num).zero?
      end

      true
    end

    prime?(n)
  end

  x.report('each:') do
    def prime?(number)
      return true if number == 2
      return false if number < 2 or number.even?
      loop_count = Math.sqrt(number).floor

      (3..loop_count).step(2).each do |num|
        return false if (number % num).zero?
      end

      true
    end

    prime?(n)
  end

  x.report('all?:') do
    def prime?(number)
      return true if number == 2
      return false if number < 2 or number.even?
      3.step(Math.sqrt(number).floor, 2).all? { |i| (number % i).nonzero? }
    end

    prime?(n)
  end

  x.report('recurse:') do
    def prime?(number, loop_count=0, loop_current=3)
      return true if number == 2 or number == 3 or number == 5
      return false if number == 1 or number.even? or (number % loop_current).zero?
      loop_count = Math.sqrt(number).floor if loop_count.zero?
      @prime = true

      @prime = prime?(number, loop_count, loop_current + 2) if loop_current < loop_count

      @prime
    end

    prime?(n)
  end
end
