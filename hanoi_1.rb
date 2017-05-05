@n = gets.to_i
@t = gets.to_i
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
