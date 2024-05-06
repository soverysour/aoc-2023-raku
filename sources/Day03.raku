unit module Day3;

constant $input = './inputs/day03.txt';
constant $digit = 0 .. 9;

sub split-line { $^a.comb }

sub solve1 {
  my @grid = $input.IO.lines>>.&split-line;
  my $sum = 0;

  my $lines = @grid.elems;
  my $columns = @grid[0].elems;
  my @lookup[$lines;$columns];

  for 0 ..^ $lines X 0 ..^ $columns -> ($line, $column) {
    if @lookup[$line;$column] {
      next
    }

    @lookup[$line;$column] = True;
    unless @grid[$line][$column] ~~ $digit {
      next
    }

    my $col_end = $column;
    for $column ..^ $columns -> $c {
      unless @grid[$line][$c] ~~ $digit {
        last
      }

      @lookup[$line;$c] = True;
      $col_end = $c;
    }

    my @to-check = gather {
      take ($line - 1, $column - 1);
      take ($line + 1, $column - 1);
      take ($line, $column - 1);
      take ($line, $col_end + 1);
      take ($line - 1, $col_end + 1);
      take ($line + 1, $col_end + 1);
      ($column .. $col_end).map: -> $c {
        take ($line - 1, $c);
        take ($line + 1, $c)
      }
    };

    for @to-check -> ($l, $c) {
      unless $l > 0 and $c > 0 and $l < $lines and $c < $columns {
        next
      }
      my $s = @grid[$l][$c];
      if $s ~~ $digit or $s eq '.' {
        next;
      }

      $sum += +@grid[$line][$column .. $col_end].join;
      last
    }
  }

  $sum
}

sub solve2 {
  my @grid = $input.IO.lines>>.&split-line;

  my $lines = @grid.elems;
  my $columns = @grid[0].elems;
  my @lookup[$lines;$columns];
  my @numbers[$lines;$columns];

  for 0 ..^ $lines X 0 ..^ $columns -> ($line, $column) {
    if @lookup[$line;$column] {
      next
    }

    @lookup[$line;$column] = True;
    unless @grid[$line][$column] ~~ $digit {
      next
    }

    my $col_end = $column;
    for $column ..^ $columns -> $c {
      unless @grid[$line][$c] ~~ $digit {
        last
      }

      @lookup[$line;$c] = True;
      $col_end = $c;
    }

    my @to-check = gather {
      take ($line - 1, $column - 1);
      take ($line + 1, $column - 1);
      take ($line, $column - 1);
      take ($line, $col_end + 1);
      take ($line - 1, $col_end + 1);
      take ($line + 1, $col_end + 1);
      ($column .. $col_end).map: -> $c {
        take ($line - 1, $c);
        take ($line + 1, $c)
      }
    };

    for @to-check -> ($l, $c) {
      unless $l > 0 and $c > 0 and $l < $lines and $c < $columns {
        next
      }

      my $s = @grid[$l][$c];
      if $s eq '*' {
        my $number = +@grid[$line][$column .. $col_end].join;
        unless @numbers[$l;$c] {
          @numbers[$l;$c] = Array.new;
        }

        @numbers[$l;$c].push($number);
      }
    }
  }

  [+] (
    @numbers.values
      ==> grep({ $^a.defined and $^a.elems == 2 })
      ==> map({ $^a[0] * $^a[1] })
  );
}

say "Solution is &solve2()"
