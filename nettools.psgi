use strict;
use warnings;

use NetTools;

my $app = NetTools->apply_default_middlewares(NetTools->psgi_app);
$app;

