# Test::Fuzz
[![Build Status](https://travis-ci.org/FCO/Test-Fuzz.svg?branch=master)](https://travis-ci.org/FCO/Test-Fuzz)

[https://perl6advent.wordpress.com/2016/12/22/day-22-generative-testing/]([https://perl6advent.wordpress.com/2016/12/22/day-22-generative-testing/)

## Synopsis
```perl6
use lib ".";
use Test::Fuzz;

sub bla (Int $bla, Int $ble --> UInt) is fuzzed {
	$bla + $ble
}

sub ble (Int $ble) is fuzzed {
	die "it is prime!" if $ble.is-prime
}

sub bli (Str :$bli) is fuzzed {
	die "it's too long" unless $bli.chars < 10
}

sub blo ("test") is fuzzed {
	"ok"
}

multi MAIN(Bool :$fuzz!) {
	run-tests
}
```

## Description
`Test::Fuzz` is a tool to `generative/fuzz testing`.
Add the `is fuzzed` trait and `Test::Fuzz` will try to figure out the best generators to use to test your function.

To run the tests, just call the `run-tests` function.

## INSTALLATION

```
    # with panda
    > panda install Test::Fuzz

    # or, with zef
    > zef install Test::Fuzz
```