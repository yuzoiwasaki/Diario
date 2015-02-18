package Diario::Model::Nikki;
use Diario::DB;
use DateTime;
use Encode;

sub new {
  my $class = shift;
  my $teng = Diario::DB->new( connect_info => [ 'dbi:mysql:diario:localhost', 'root', undef ] );
  bless { db => $teng }, $class;
}

sub get_entries {
	my $self = shift;
	my $itr = $self->{db}->search("diario", {});
	my $entries = [];
	while ( my $data = $itr->next ) {
		$data->{row_data}{title} = decode_utf8($data->{row_data}{title});
		$data->{row_data}{description} = decode_utf8($data->{row_data}{description});
		push @$entries, $data;
	}
	@$entries = reverse @$entries;
  return $entries;
}

sub create_entries {
  my ($self, $title, $body) = @_;
	my $now = DateTime->now( time_zone => 'Asia/Tokyo' );
	my $row = $self->{db}->insert('diario', +{title => $title, description => $body, created_at => $now});
}

sub delete_entries {
  my $self = shift;
  my @articles = @_;
	for my $article(@articles) {
		my $delete = $self->{db}->delete('diario', +{id => $article});
	}
}

1;
