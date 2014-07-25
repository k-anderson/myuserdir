# shamelessly copied from http://code.google.com/p/irssi-libnotify/
# notify via tcp port and other improvements by Filippo Giunchedi <filippo@debian.org>

use strict;
use Irssi;
use HTML::Entities;
use vars qw($VERSION %IRSSI);

$VERSION = "0.01";

%IRSSI = (
    authors     => 'Luke Macken, Paul W. Frields',
    contact     => 'lewk@csh.rit.edu, stickster@gmail.com',
    name        => 'rnotify',
    description => 'Use libnotify to alert user to hilighted messages',
    license     => 'GNU General Public License',
    url         => 'http://lewk.org/log/code/irssi-notify',
);

Irssi::settings_add_str('misc', $IRSSI{'name'} . '_port', '12000');

sub notify {
    my ($server, $summary, $message) = @_;

    $message = HTML::Entities::encode($message);
    $summary = HTML::Entities::encode($summary);

    # echo \ escaping
    $message =~ s/\\/\\\\/g;
    $summary =~ s/\\/\\\\/g;

    my $port = Irssi::settings_get_str($IRSSI{'name'} . '_port');

    system("echo -e '$summary\n$message' | /usr/bin/nc 127.0.0.1 $port > /dev/null 2>&1");
}
 
sub print_text_notify {
    my ($dest, $text, $msg) = @_;
    my $server = $dest->{server};

    return if (!$server || !($dest->{level} & MSGLEVEL_HILIGHT));
    notify($server, "IRC-MSG $dest->{target}", $msg);
}

sub message_private_notify {
    my ($server, $msg, $nick, $address) = @_;

    return if (!$server);
    notify($server, "IRC-PM ".$nick, $msg);
}

sub dcc_request_notify {
    my ($dcc, $sendaddr) = @_;
    my $server = $dcc->{server};

    return if (!$dcc);
    notify($server, "IRC-DCC ".$dcc->{type}." request", $dcc->{nick});
}

Irssi::signal_add('print text', 'print_text_notify');
Irssi::signal_add('message private', 'message_private_notify');
Irssi::signal_add('dcc request', 'dcc_request_notify');

# vim: et
