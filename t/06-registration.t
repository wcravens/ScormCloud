#!perl -T

use strict;
use warnings;

use Test::More tests => 21;

require './t/_test_util.pl';

my $ScormCloud = getScormCloudObject();

##########

can_ok($ScormCloud, 'getRegistrationList');

my $registration_list;

$registration_list =
  $ScormCloud->getRegistrationList({filter => 'i do not exist'});
isa_ok($registration_list, 'ARRAY', '$ScormCloud->getRegistrationList');
is(scalar(@{$registration_list}), 0, '$ScormCloud->getRegistrationList empty');

$registration_list =
  $ScormCloud->getRegistrationList({coursefilter => 'i do not exist'});
isa_ok($registration_list, 'ARRAY', '$ScormCloud->getRegistrationList');
is(scalar(@{$registration_list}), 0, '$ScormCloud->getRegistrationList empty');

$registration_list = $ScormCloud->getRegistrationList;
isa_ok($registration_list, 'ARRAY', '$ScormCloud->getRegistrationList');

can_ok($ScormCloud, 'getRegistrationResult');

SKIP:
{
    skip 'No registrations exist for further testing', 14
      unless @{$registration_list} > 0;

    my $registration_id = $registration_list->[0]->{id};

    my $result = $ScormCloud->getRegistrationResult($registration_id);
    isa_ok($result, 'HASH', '$ScormCloud->getRegistrationResult');

    my %expected = (
                    complete => '',
                    score    => '',
                    success  => '',
                   );

    foreach my $key (sort keys %expected)
    {
        ok(exists $result->{$key},
            "\$ScormCloud->getRegistrationResult includes $key");
        is(ref($result->{$key}),
            $expected{$key},
            "ref(\$ScormCloud->getRegistrationResult->{$key})");
    }

    $result = $ScormCloud->getRegistrationResult($registration_id, 'full');
    isa_ok($result, 'HASH', '$ScormCloud->getRegistrationResult');

    %expected = (
                 activity => 'ARRAY',
                 format   => '',
                 regid    => '',
                );

    foreach my $key (sort keys %expected)
    {
        ok(exists $result->{$key},
            "\$ScormCloud->getRegistrationResult includes $key");
        is(ref($result->{$key}),
            $expected{$key},
            "ref(\$ScormCloud->getRegistrationResult->{$key})");
    }
}
