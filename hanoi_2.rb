def main
  d = [[*1..n].reverse, [], []]
  t.times do |i|
      small, other, big = 3.times.sort_by{|j|d[j][-1] || 99}
      if i.even?
          d[small - 2 + n % 2] << d[small].pop
      else
          d[big] << d[other].pop
      end
  end
  n.times do |j|
      3.times.map{|i|
          t = d[i][n-j-1]
          (t ? ?#*(2*t+1) : ?|).center(2*n+1)
      }.join(" ").rstrip
  end
  2**n-1
end

main
