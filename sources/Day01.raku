unit module Day1;

constant $input = './inputs/day01.txt';
constant %digit_map = (
  "0" => "0",
  "1" => "1",
  "2" => "2",
  "3" => "3",
  "4" => "4",
  "5" => "5",
  "6" => "6",
  "7" => "7",
  "8" => "8",
  "9" => "9",
  "zero" => "0",
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9",
);

sub finder (Str:D $line) {
  my @symbols = $line.match(/\d|zero|one|two|three|four|five|six|seven|eight|nine/, :overlap);

  given @symbols.elems {
    when 0 {}

    my $first = %digit_map{@symbols[0]};
    when 1 { take +($first ~ $first) }

    my $last = %digit_map{@symbols[*-1]};
    default { take +($first ~ $last) }
  }
}

sub solve {
  [+] gather { $input.IO.lines>>.&finder }
}

say "Solution is: &solve()"
