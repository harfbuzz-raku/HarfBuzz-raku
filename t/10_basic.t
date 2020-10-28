use HarfBuzz;
use HarfBuzz;
use Test;
plan 1;
my $file = 't/fonts/NimbusRoman-Regular.otf';
my HarfBuzz $hb .= new: :$file;
$hb.size = 36;
is $hb.size, 36;
##$hb.text = "Hell€!";
##my $info = $hb->shaper;
### use DDumper; DDumper($info);
##my $result = [
##  {
##    ax => '25.992',
##    ay => 0,
##    dx => 0,
##    dy => 0,
##    g => 41,
##    name => 'H',
##  },
##  {
##    ax => '15.192',
##    ay => 0,
##    dx => 0,
##    dy => 0,
##    g => 70,
##    name => 'e',
##  },
##  {
##    ax => '10.008',
##    ay => 0,
##    dx => 0,
##    dy => 0,
##    g => 77,
##    name => 'l',
##  },
##  {
##    ax => '10.008',
##    ay => 0,
##    dx => 0,
##    dy => 0,
##    g => 77,
##    name => 'l',
##  },
##  {
##    ax => 18,
##    ay => 0,
##    dx => 0,
##    dy => 0,
##    g => 347,
##    name => 'Euro',
##  },
##  {
##    ax => '11.988',
##    ay => 0,
##    dx => 0,
##    dy => 0,
##    g => 2,
##    name => 'exclam',
##  },
##];
##
##ok(compare( $info, $result ), "content" );
##
##sub compare {
##    my ( $soll, $ist ) = @_;
##    unless ( @$ist == @$soll ) {
##	diag( scalar(@$ist) . " elements, must be " . scalar(@$soll) );
##	return;
##    }
##
##    for ( 0 .. @$ist-1 ) {
##	my $i = $ist->[$_];
##	my $j = $soll->[$_];
##	unless ( $i->{g} == $j->{g} ) {
##	    diag( "CId $i->{g} must be $j->{g}" );
##	    return;
##	}
##	# It's a pity this font does not have glyph names.
##	# But harbuzz 2.6.6 started to return them.
##	unless ( $i->{name} eq $j->{name} or '' eq $j->{name}) {
##	    diag( "Name $i->{name} must be $j->{name}" );
##	    return;
##	}
##	for ( qw( ax ay dx dy ) ) {
##	    next if $i->{$_} == $j->{$_};
##	    unless ( abs( $i->{$_} - $j->{$_} ) <= abs($j->{$_} / 100) ) {
##		diag( "$_ $i->{$_} must be $j->{$_}" );
##		return;
##	    }
##	}
##    }
##    return 1;
##}
##
