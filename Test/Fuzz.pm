use Test;
class Test::Fuzz {
	class Fuzzer {
		has		$.name;
		has 		@.data;
		has Block	$.func;
		has 		$.returns;

		method run() is hidden-from-backtrace {
			subtest {
				for @.data -> @data {
					my $return = $.func.(|@data);
					$return.exception.throw if $return ~~ Failure;
					CATCH {
						default {
							lives-ok {
								.throw
							}, "{ $.name }({ @data.join(", ") })"
						}
					}
					pass "{ $.name }({ @data.join(", ") })"
				}
			}, $.name
		}
	}

	my %generator{Mu:U};

	%generator{UInt} = gather {
		take 0;
		take 1;
		take 3;
		take 9999999999;
		take $_ for (^10000000000).roll(*)
	};

	%generator{Int}	= gather for @( %generator{UInt} ) -> $int {
		take $int;
		take -$int unless $int == 0;
	};

	my Fuzzer @fuzzers;

	sub fuzz(Routine $func, :$fuzzed) is export {
		my $counter	= 10;

		my @data = [X] $func.signature.params.map(-> \param {
			my $type = param.type;
			$?CLASS.generate($type, $counter)
		});
		if $func.signature.params.elems <= 1 {
			@data = @data[0].map(-> $item {[$item]});
		}

		my $name	= $func.name;
		my $returns	= $func.signature.returns;

		@fuzzers.push(Fuzzer.new(:$name:$func:@data:$returns))
	}

	multi trait_mod:<is> (Routine $func, :$fuzzed!) is export {
		fuzz($func, :$fuzzed);
	}

	method generate(Test::Fuzz:U: ::Type, Int \size) {
		my $ret;
		if %generator{Type}:exists {
			$ret = %generator{Type}[^size]
		}
		$ret
	}

	method run-tests(Test::Fuzz:U:) {
		#say @fuzzers;
		for @fuzzers -> $fuzz {
			$fuzz.run;
		}
	}
}
