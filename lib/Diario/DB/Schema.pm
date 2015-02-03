package Diario::DB::Schema;
use Teng::Schema::Declare;
use DateTime::Format::MySQL;

table {
	name 'diario';
	pk 'id';
	columns qw/id title description created_at/;
	inflate qr/created_at/ => sub {
		my $value = shift;
		return DateTime::Format::MySQL->parse_datetime($value);
	};
	deflate qr/created_at/ => sub {
		my $value = shift;
		return DateTime::Format::MySQL->format_datetime($value);
	};
};

1;
