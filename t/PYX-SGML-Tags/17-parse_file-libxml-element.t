use strict;
use warnings;

use English;
use File::Object;
use PYX::SGML::Tags;
use Unicode::UTF8 qw(decode_utf8);
use Test::More 'tests' => 5;
use Test::NoWarnings;

SKIP: {
	eval {
		require Tags::Output::LibXML;
	};
	if ($EVAL_ERROR) {
		skip "Module 'Tags::Output::LibXML' isn't present.", 4;
	}

	# Directories.
	my $data_dir = File::Object->new->up->dir('data');

	# Test.
	my $tags = Tags::Output::LibXML->new;
	my $obj = PYX::SGML::Tags->new(
		'tags' => $tags,
	);
	$obj->parse_file($data_dir->file('element1.pyx')->s);
	is($tags->flush, "<element />", 'Simple element (xml version).');
	$tags->reset;

	# Test.
	$obj->parse_file($data_dir->file('element2.pyx')->s);
	is($tags->flush, "<element par=\"val\" />",
		'Simple element with attribute (xml version).');
	$tags->reset;

	# Test.
	$obj->parse_file($data_dir->file('element3.pyx')->s);
	is($tags->flush, "<element par=\"val\\nval\" />",
		'Simple element with attribute with \n in value (xml version).');
	$tags->reset;

	# Test.
	$obj->parse_file($data_dir->file('element4.pyx')->s);
	is($tags->flush, decode_utf8('<čupřina cíl="ředkev" />'),
		'Parse element with attribute in utf-8 (xml version).');
	$tags->reset;
};
