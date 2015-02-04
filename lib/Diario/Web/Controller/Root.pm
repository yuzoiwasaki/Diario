package Diario::Web::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';
use Diario::DB;
use DateTime;
use Encode;

my $teng = Diario::DB->new( connect_info => [ 'dbi:mysql:diario:localhost', 'root', undef ] );

sub index {
	my $self = shift;
	my $itr = $teng->search("diario", {});
	my $entries = [];
	while ( my $data = $itr->next ) {
		$data->{row_data}{title} = decode_utf8($data->{row_data}{title});
		$data->{row_data}{description} = decode_utf8($data->{row_data}{description});
		push @$entries, $data;
	}
	@$entries = reverse @$entries;
	$self->stash->{entries} = $entries;
	$self->render();
}

sub post {
	my $self = shift;
	$self->render();
}

sub create {
	my $self = shift;
	my $title = $self->param('title');
	my $body = $self->param('body');
	my $now = DateTime->now( time_zone => 'Asia/Tokyo' );
	my $row = $teng->insert('diario', +{title => $title, description => $body, created_at => $now});
	$self->redirect_to('/');
}

sub delete {
	my $self = shift;
	my @articles = $self->every_param('delete');
	for my $article(@articles) {
		my $delete = $teng->delete('diario', +{id => $article});
	}
	$self->redirect_to('/');
}

1;
