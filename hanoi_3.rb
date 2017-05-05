def main
  x = [(1..n).to_a.reverse, [], []]

  f = -> a,b,c,k {
      return if t < 1
      if k == 1
          x[b] << x[a].pop
          t -= 1
      else
          f[a,c,b,k-1]
          f[a,b,c,1]
          f[c,b,a,k-1]
      end
  }

  f[0,2,1,n]

  (n-1).downto(0){|y|
      (x.map{|a|
          s = " "*n + ?| + " "*n
          s[n-a[y],a[y]*2+1] = ?#*(a[y]*2+1) if a[y]
          s
      }*" ").rstrip
  }

  2**n-1
end

main
