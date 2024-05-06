unit module Day1;

constant $input = './inputs/day02.txt';
constant %dice_bag = (
  red   => 12,
  green => 13,
  blue  => 14,
);

sub select-bad-games(Str:D $line) {
  $line ~~ rx:s/^Game $<game-id>=(\d+)\: $<dice>=(<[\w\d\s,;]>+)$/;

  my @games = $<dice>.split(';')>>.&trim;
  my $game-id = +$<game-id>;
  my $valid = True;

  GAMES: for @games -> $game {
    my @dice = $game.split(',')>>.&trim;

    for @dice -> $dic {
      $dic ~~ rx:s/^$<dice-count>=(\d+) $<dice-type>=(\w+)$/;

      if %dice_bag{$<dice-type>} < +$<dice-count> {
        $valid = False;
        last GAMES
      }
    }
  }

  take $game-id if $valid;
}

sub find-min-set(Str:D $line) {
  $line ~~ rx:s/^Game \d+\: $<dice>=(<[\w\d\s,;]>+)$/;

  my @games = $<dice>.split(';')>>.&trim;
  my %minimals = (
    red   => 0,
    green => 0,
    blue  => 0,
  );

  for @games -> $game {
    my @dice = $game.split(',')>>.&trim;

    for @dice -> $dic {
      $dic ~~ rx:s/^$<dice-count>=(\d+) $<dice-type>=(\w+)$/;

      %minimals{$<dice-type>} max= +$<dice-count>;
    }
  }

  take [*] %minimals.values
}

sub solve1 {
  [+] gather { $input.IO.lines>>.&select-bad-games }
}

sub solve2 {
  [+] gather { $input.IO.lines>>.&find-min-set }
}

say "Solution is &solve2()"
