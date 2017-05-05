require 'benchmark'

n = 10
t = 512

Benchmark.bm(10) do |x|
  # x.config(time: 2, warmup: 2)

  x.report('0:') do
    def main(n, t)
      initialize_game(n, t)
      move_disc until game_is_over?

      solution
    end

    def initialize_game(n, t)
      @number_of_discs = n
      @goal_turn = t
      @turn = 0
      @towers = [new_tower, new_tower, new_tower]
    end

    def new_tower
      tower = Array.new(@number_of_discs, 0)

      tower.fill { |i| i + 1 } if @first.nil?
      tower << Float::INFINITY

      @first = false

      tower
    end

    def move_disc
      @turn += 1

      if @turn.odd?
        move_smallest
      else
        move_only_other_moveable_disc
      end
    end

    def game_is_over?
      goal_turn_is_reached? or puzzle_is_solved?
    end

    def goal_turn_is_reached?
      @goal_turn == @turn
    end

    def puzzle_is_solved?
      @turn == 2 ** @number_of_discs - 1
    end

    def move_smallest
      remove_disc 1

      @number_of_discs.odd? ? move(1, 'left') : move(1, 'right')
    end

    def move_only_other_moveable_disc
      tops = find_tops
      disc = tops.sort[1]

      # regex matches disc not 1 or itself
      target = tops.index { |i| i.to_s =~ /[^1#{disc}]/ }

      remove_disc disc
      move(disc, target)
    end

    def remove_disc(number)
      origin = find_disc(number)
      @towers[@current][origin] = 0
    end

    def find_disc(number)
      @current = 0
      disc = 0

      @towers.each do |tower|
        disc = tower.index number
        break unless disc.nil?
        @current += 1
      end

      disc
    end

    def find_tops
      discs = @towers.map { |tower| tower.select { |disc| not(disc.zero?) }.min }

      discs.map { |disc| disc.nil? ? 0 : disc }
    end

    def move(disc, target)
      target = @current - 1 if target == 'left'
      target = @current - 2 if target == 'right'
      @towers[target][@towers[target].rindex(0)] = disc
    end

    def get_state
      state = ''
      @number_of_discs.times do |row|
        state << build_row(row)
      end

      state
    end

    def build_row(row)
      state = ''

      3.times do |col|
        state << build_tower_row(row, col)
      end

      state << "\n"

      state
    end

    def build_tower_row(row, col)
      tower = @towers[col]
      disc = tower[row]
      padding = @number_of_discs - tower[row]
      piece = ''

      piece << draw(padding, ' ')
      disc.zero? ? piece << '|' : piece << draw(disc_width(disc), '#')
      piece << draw(padding + 1, ' ') unless col == 2

      piece
    end

    def draw(number, symbol)
      part = ''
      number.times { part << symbol }

      part
    end

    def disc_width(disc)
      disc * 2 + 1
    end

    def solution
      "#{get_state}#{2 ** @number_of_discs - 1}"
    end

    main n, t
  end

  x.report('1:') do
    @n = n
    @t = t
    @i = 0
    @s = {}
    @s[?A] = @n.downto(1).to_a
    @s[?B] = []
    @s[?C] = []



    def hanoi (n,src,via,dst)
        hanoi n-1,src,dst,via if n>1

        @i += 1
        @s[dst].push @s[src].pop
        display_state if @i == @t

        hanoi n-1,via,src,dst if n>1
    end

    def display_state
       art = []
       art.concat pretty_stack ?A
       art.concat [[" "]*@n]
       art.concat pretty_stack ?B
       art.concat [[" "]*@n]
       art.concat pretty_stack ?C

       art.transpose.map {|s| s.join.rstrip}
    end

    def pretty_stack (z)
        @s[z].dup.concat([nil]*(@n-@s[z].size)).reverse.
            map {|x| x ? ?# * (2*x+1) : ?| }.
                map {|s| s.center(2*@n+1)}.
                    map(&:chars).transpose
    end

    hanoi @n,?A,?B,?C
    @i
  end

  x.report('2:') do
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

  x.report('3:') do
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
end
