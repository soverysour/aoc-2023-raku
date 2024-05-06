unit module Day3;

constant $input = './inputs/day04.txt';

sub numbers-to-set {
  Set.new(($^a ~~ m:g/\d+/ ==> map(+*.Str)))
}

sub cost-per-card(Str:D $line) {
  $line ~~ /^Card\s+\d+\:$<winners>=(<[\d\s]>+)\|$<choices>=(<[\d\s]>+)$/;

  my $wins = numbers-to-set($<winners>);
  my $chosen = numbers-to-set($<choices>);
  my $win-count = ($wins (&) $chosen).elems;

  if $win-count > 0 {
    my $result = 1;
    for 1 ..^ $win-count {
      $result *= 2;
    }

    take $result;
  }
}

sub parse-cards(Str:D $line) {
  $line ~~ /^Card\s+$<card-id>=(\d+)\:$<winners>=(<[\d\s]>+)\|$<choices>=(<[\d\s]>+)$/;

  my $wins = numbers-to-set($<winners>);
  my $chosen = numbers-to-set($<choices>);
  my $win-count = ($wins (&) $chosen).elems;

  {
    id  => +$<card-id>.Str - 1,
    won => $win-count,
  }
}

sub solve1 {
  [+] gather { $input.IO.lines>>.&cost-per-card }
}

sub solve2 {
  my @card-descriptors = $input.IO.lines>>.&parse-cards;
  my $total-card-count = @card-descriptors.elems;

  my @old-population = @card-descriptors.clone;
  my @new-population = ();

  while @old-population.elems > 0 {
    for @old-population -> $card {
      WINNINGS: for $card<id> + 1 .. $card<id> + $card<won> -> $next-card-id {
        unless $next-card-id < @card-descriptors.elems {
          last WINNINGS
        }
        @new-population.push(@card-descriptors[$next-card-id])
      }
    }

    @old-population = @new-population;
    @new-population = ();
    $total-card-count += @old-population.elems
  }

  $total-card-count
}

say "Solution is &solve2()"
