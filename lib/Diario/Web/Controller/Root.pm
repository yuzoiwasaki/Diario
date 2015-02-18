package Diario::Web::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';
use Diario::Model::Nikki;

sub index {
  my $self = shift;
  my $entries = $self->model->get_entries();
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
  $self->model->create_entries($title, $body);
	$self->redirect_to('/');
}

sub delete {
	my $self = shift;
	my @articles = $self->every_param('delete');
  $self->model->delete_entries(@articles);
	$self->redirect_to('/');
}

1;
