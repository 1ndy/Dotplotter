package DotPlot;

use strict;
use warnings;
use GD;

# sub new {
#     my ($classname, $args) = @_;
#     my $self = bless { seq1 => $args->{seq1},
#                        seq2 => $args->{seq2},
#                        scale => $args->{scale},
#                        min_chain_length => $args->{minChainLen}
#                     }, $classname;
#     return $self;
# }

sub new {
    my ($classname, $seq1, $seq2, $scale, $min_chain_length) = @_;
    my $self = bless { seq1 => $seq1,
                       seq2 => $seq2,
                       scale => $scale,
                       min_chain_length => $min_chain_length
                    }, $classname;
    return $self;
}

sub drawPlot {
    my $self = shift;
    my $img = new GD::Image(length($self->{seq1}), length($self->{seq2}));
    my $final = new GD::Image(length($self->{seq1}) * $self->{scale}, length($self->{seq2}) * $self->{scale});
    $img->interlaced('true');
    my $black = $img->colorAllocate(0,0,0);
    my $white = $img->colorAllocate(255,255,255);
    my $red = $img->colorAllocate(255,0,0);
    my @s1 = split //,$self->{seq1};
    my @s2 = split //,$self->{seq2};
    $img->fill(0,0,$white);
    my @chain;
    for(my $i = 0; $i < scalar(@s1); $i++) {
        for(my $j = 0; $j < scalar(@s2); $j++) {
            if($s1[$i] eq $s2[$j] && $img->getPixel($i, $j) ne $red) {
                my $x = $i;
                my $y = $j;
                while($x < scalar(@s1) && $y < scalar(@s2) && ($s1[$x] eq $s2[$y])) {
                    push @chain, ($x, $y);
                    $x++;
                    $y++;
                }
                if(@chain / 2 >= $self->{min_chain_length}) {
                    for(my $k = 0; $k < scalar(@chain); $k+=2) {
                        $img->setPixel($chain[$k], $chain[$k+1], $red);
                    }
                } else {
                    for(my $k = 0; $k < scalar(@chain); $k+=2) {
                        $img->setPixel($chain[$k], $chain[$k+1], $black) unless $img->getPixel($i, $j) == $red;
                    }
                }
                @chain = ();
            } else {
                $img->setPixel($i, $j, $white) unless $img->getPixel($i, $j) == $red or $img->getPixel($i, $j) == $black;
            }
        }
    }
    $final->interlaced('true');
    $final->copyResized($img, 0,0,0,0,length($self->{seq1}) * $self->{scale},length($self->{seq2}) * $self->{scale},scalar(@s1), scalar(@s2));
    return $final->png;
}

1;