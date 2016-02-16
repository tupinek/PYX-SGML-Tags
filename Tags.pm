package PYX::SGML::Tags;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Error::Pure qw(err);
use PYX::Parser;
use PYX::Utils qw(encode);
use Tags::Output::Raw;

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;
	my $self = bless {}, $class;

	# Tags object.
	$self->{'tags'} = Tags::Output::Raw->new;

	# Process params.
	set_params($self, @params);

	# Check for Tags::Output object.
	if (! $self->{'tags'}
		|| ! $self->{'tags'}->isa('Tags::Output')) {

		err "Bad 'Tags::Output::*' object.";
	}

	# PYX::Parser object.
	$self->{'pyx_parser'} = PYX::Parser->new(
		'callbacks' => {
			'attribute' => \&_attribute,
			'comment' => \&_comment,
			'data' => \&_data,
			'end_element' => \&_end_element,
			'instruction' => \&_instruction,
			'start_element' => \&_start_element,
		},
		'non_parser_options' => {
			'tags' => $self->{'tags'},
		},
	);

	# Object.
	return $self;
}

# Parse pyx text or array of pyx text.
sub parse {
	my ($self, $pyx, $out) = @_;
	$self->{'pyx_parser'}->parse($pyx, $out);
	return;
}

# Parse file with pyx text.
sub parse_file {
	my ($self, $file) = @_;
	$self->{'pyx_parser'}->parse_file($file);
	return;
}

# Parse from handler.
sub parse_handler {
	my ($self, $input_file_handler, $out) = @_;
	$self->{'pyx_parser'}->parse_handler($input_file_handler, $out);
	return;
}

# Process start of element.
sub _start_element {
	my ($self, $elem) = @_;
	my $tags = $self->{'non_parser_options'}->{'tags'};
	$tags->put(['b', $elem]);
	return;
}

# Process end of element.
sub _end_element {
	my ($self, $elem) = @_;
	my $tags = $self->{'non_parser_options'}->{'tags'};
	$tags->put(['e', $elem]);
	return;
}

# Process data.
sub _data {
	my ($self, $data) = @_;
	my $tags = $self->{'non_parser_options'}->{'tags'};
	$tags->put(['d', encode($data)]);
	return;
}

# Process attribute.
sub _attribute {
	my ($self, $attr, $value) = @_;
	my $tags = $self->{'non_parser_options'}->{'tags'};
	$tags->put(['a', $attr, $value]);
	return;
}

# Process instruction tag.
sub _instruction {
	my ($self, $target, $code) = @_;
	my $tags = $self->{'non_parser_options'}->{'tags'};
	$tags->put(['i', $target, $code]);
	return;
}

# Process comments.
sub _comment {
	my ($self, $comment) = @_;
	my $tags = $self->{'non_parser_options'}->{'tags'};
	$tags->put(['c', encode($comment)]);
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

PYX::SGML::Tags - TODO

=head1 SYNOPSIS

TODO

=head1 METHODS

=over 8

=item C<new()>

Constructor.

=over 8

=item * C<tags>

 Tags object.
 Default value is Tags::Output::Raw->new.
 It's required.

=back

=item C<parse()>

 TODO

=item C<parse_file()>

 TODO

=item C<parse_handler()>

 TODO

=back

=head1 ERRORS

 new():
         Bad 'Tags::Output::*' object.
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

 TODO PYX::Parser

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 # TODO

 # TODO

 # Output:
 # TODO

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<PYX::Parser>,
L<PYX::Utils>,
L<Tags::Output::Raw>.

=head1 SEE ALSO

=over

=item L<Task::PYX>

Install the PYX modules.

=back

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

 © 2011-2016 Michal Špaček
 BSD 2-Clause License

=head1 VERSION

0.01

=cut
