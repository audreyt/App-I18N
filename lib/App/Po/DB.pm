package App::Po::DB;
use warnings;
use strict;
use DBI;
use Any::Moose;

has dbh => 
    ( is => 'rw' );

has lang => 
    ( is => 'rw' , isa => 'Str' );

sub BUILD {
    my ($self,$args) = @_;
    # my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","");
    my $dbh = DBI->connect("dbi:SQLite:dbname=:memory:","","",
            { RaiseError     => 1, sqlite_unicode => 1, });
    my $rv = $dbh->do( qq|create table po_string (  
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            lang TEXT,
            msgid TEXT,
            msgstr TEXT
        );|);
    $self->dbh( $dbh );
}

sub insert {
    my ( $self, $msgid, $msgstr , $lang ) = @_;
    $lang ||= $self->lang;
    my $sth = $self->dbh->prepare(
        qq| INSERT INTO po_string (  lang , msgid , msgstr ) VALUES ( ? , ? , ? ); |);
    $sth->execute( $lang, $msgid, $msgstr );
}

sub find {
    my ( $self, $msgid ) = @_;
    my $lang = $self->lang;
    my $sth = $self->dbh->prepare(qq| SELECT * FROM po_string WHERE lang = ? AND msgid = ? LIMIT 1;|);
    $sth->execute( $lang, $msgid );
    my @data = $sth->fetchrow_array();
    return MsgEntry->new( 
        id => $data[0],
        lang  => $data[1],
        msgid => $data[2],
        msgstr => $data[3],
    );
}

sub fetch_table {
    my $self = shift;
    my $sth  =$self->dbh->prepare( qq| select * from po_string where lang = ? | );
    $sth->execute( $self->lang );
    my @result;
    while( my $row = $sth->fetchrow_hashref ) {
        push @result, MsgEntry->new(
            id     => $row->{id},
            lang   => $row->{lang},
            msgid  => $row->{msgid},
            msgstr => $row->{msgstr},
        );
    }
    return \@result;
}


sub import_lexicon {
    my ( $self, $lex ) = @_;
    while ( my ( $msgid, $msgstr ) = each %$lex ) {
        $self->insert( $msgid, $msgstr, $lang );
    }
}


sub import_po {
    my ( $self, $lang, $pofile ) = @_;
    my $lme = App::Po->lm_extract;
    $lme->read_po($pofile) if -f $pofile && $pofile !~ m/pot$/;
    $self->import_lexicon( $lme->lexicon );
}

sub export_lexicon {
    my ($self) = @_;
    my $lexicon;


    return $lexicon;
}

sub export_po {
    my ( $self, $podir ) = @_;

    # $lme->write_po($pofile);
}


package MsgEntry;
use Any::Moose;

has id => ( is => 'rw', isa => 'Int' );
has lang  => ( is => 'rw' , isa => 'Str' );
has msgid => ( is => 'rw' , isa => 'Str' );
has msgstr => ( is => 'rw' , isa => 'Str' );

1;
