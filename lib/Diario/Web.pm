package Diario::Web;
use Mojo::Base 'Mojolicious';

sub startup {
  my $self = shift;
  my $r = $self->routes;
  $r->namespaces([qw/Diario::Web::Controller/]);
  $r->get('/')->to('root#index');
  $r->get('/new')->to('root#post');
  $r->post('/create')->to('root#create');
  $r->post('/delete')->to('root#delete');
}

1;
