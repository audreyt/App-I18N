package App::Po::Command::Server;
use warnings;
use strict;
use base qw(App::Po::Command);
use App::Po::Web::View;
use Tatsumaki::Application;
use Plack::Runner;
use File::Basename;
use File::ShareDir qw();

sub options {
    (

    )
}

sub run {
    my ($self) = @_;

    Template::Declare->init( dispatch_to => ['App::Po::Web::View'] );

    my $app = Tatsumaki::Application->new([
        "(.*)" => "RootHandler"
    ]);


    my $shareroot;


    if( -e "./share" ) {
        $shareroot = 'share' ;
    }
    else {
        $shareroot = File::ShareDir::dist_dir( "App-Po" );
    }

    $app->template_path( $shareroot . "/templates" );
    $app->static_path( $shareroot . "/static" );

    my $runner = Plack::Runner->new;
    $runner->parse_options(@ARGV);
    $runner->run($app->psgi_app);
}

package RootHandler;
use base qw(Tatsumaki::Handler);
use Tatsumaki;
use Tatsumaki::Error;
use Tatsumaki::Application;
use Template::Declare;

sub post {
    my ($self,$path) = @_;


    $self->finish({ success => 1 });
}

sub get {
    my ( $self, $path ) = @_;
    $path ||= "/";
    $self->write( Template::Declare->show( $path, $self ) );
    $self->finish;
}

1;