use strict;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";
use DBI;
use SQL::SplitStatement;
use Path::Tiny;
use Test::mysqld;
use Diario::Model::Nikki;

subtest 'nikki' => sub {
  my $mysqld = Test::mysqld->new(
    my_cnf => {
      'skip-networking' => '',
    }
  ) or die $Test::mysqld::errstr;

  my $dbh = DBI->connect( $mysqld->dsn, 'root', undef );
  my $schema_file = path( 'etc', 'diario_schema.sql' );
  my $schema_sql = $schema_file->slurp();
  my $initial_sql = <<"SQL";

USE test;
$schema_sql
SQL

  my $splitter = SQL::SplitStatement->new(
    keep_terminator       => 1,
    keep_comments         => 0,
    keep_empty_statement  => 0,
  );

  for ( $splitter->split($initial_sql) ) {
    $dbh->do($_) or die( $dbh->errstr );
  }
  my $dsn = $mysqld->dsn();
  ok $dsn;

  use_ok 'Diario::Model::Nikki';

  my $obj = Diario::Model::Nikki->new;
  isa_ok $obj, 'Diario::Model::Nikki';

  ok $obj->create_entries('hoge', 'fuga');

  my $entries = $obj->get_entries;
  is @$entries->[0]->{row_data}{title}, 'hoge';
  is @$entries->[0]->{row_data}{description}, 'fuga';
};

done_testing();
