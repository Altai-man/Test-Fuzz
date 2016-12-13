use lib ".";
use Test::Fuzz;

sub bla (Int $bla, Int $ble --> UInt) is fuzzed {
	$bla + $ble
}

sub ble (Int $ble) is fuzzed {
	die "it is prime!" if $ble.is-prime
}

sub bli (Int $bli) is fuzzed(:counter(6)) {}

sub blo (UInt $blo) is fuzzed {
	return $blo
}

subset Prime of UInt where {not .defined or .is-prime};

sub blu (Prime $blu) is fuzzed({test => not *.is-prime}) {
	return $blu * $blu
}

sub pla ($value --> True) is fuzzed {}

multi MAIN(Bool :$fuzz!) {
	Test::Fuzz.instance.run-tests
}

multi MAIN(Str :$fuzz!) {
	my @funcs = $fuzz.split(/\s+/);
	say "Running tests for {@funcs}";
	Test::Fuzz.instance.run-tests: @funcs
}

multi MAIN {
	say bla(1, 2);
	ble(4);
	bli(42);
	say blo(42);
}
