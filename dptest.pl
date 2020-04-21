use lib '.';

use strict;
use warnings;

use DotPlot;
use Bio::DB::SwissProt;

my $min_chain_length = 3;
my $db_obj = Bio::DB::SwissProt->new;
my $hagfish = $db_obj->get_Seq_by_id('Q5QID7_MELCB');
my $lamprey = $db_obj->get_Seq_by_id('ATP6_PETMA');

my $dp = DotPlot->new($hagfish->seq, $lamprey->seq, 8, 3);
my $output = $dp->drawPlot();
print $output; #redirect this to a .png