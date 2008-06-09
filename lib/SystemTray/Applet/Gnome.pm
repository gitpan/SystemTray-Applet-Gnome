package SystemTray::Applet::Gnome;

use warnings;
use strict;

use base qw( SystemTray::Applet );

use Gtk2;
use Gtk2::TrayIcon;

=head1 NAME

SystemTray::Applet::Gnome - Gnome support for SystemTray::Applet

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This module provides gnome support for SystemTray::Applet.

    use SystemTray::Applet::Gnome;

    my $foo = SystemTray::Applet::CmdLine->create( "text" => "hello world" );

=head1 FUNCTIONS

=cut


=head2 init

 $self->init();

Initialize the toolkit env. Sets up Gtk2 and creates a tray icon.

=cut

sub init
{
	my ( $self ) = @_;

	Gtk2->init();

	$self->{"gnome"}->{"applet"} = Gtk2::TrayIcon->new("");
	unless( $self->{"gnome"}->{"applet"} )
	{
		warn( "Unable to create gnome tray icon" );
		return undef;	
	}

	$self->{"gnome"}->{"label"} = Gtk2::Label->new("loading");
	$self->{"gnome"}->{"applet"}->add($self->{"gnome"}->{"label"});
	$self->{"gnome"}->{"applet"}->show_all();

	return $self;
}


=head2 start

 $self->start();

Start the gui up by starting the gtk mainloop. Never returns.

=cut

sub start
{
	Gtk2->main();
	exit(0);
}


=head2 create_icon

 $self->create_icon("an_icon.jpg" );

Create an icon from a file and return it. Supports whatever gtk2::Image does.

=cut

sub create_icon
{
	my ( $self , $icon ) = @_;

	my $image = Gtk2::Image->new_from_file($icon);
	return $image;
}


=head2 display

 $self->display();

Display the icon with the text as hovertext if we have an icon or just the text if not.

=cut

sub display
{
	my ( $self ) = @_;
	if( $self->{"icon"} )
	{
		my @children = $self->{"gnome"}->{"applet"}->get_children();
		foreach my $child( @children )
		{
			$self->{"gnome"}->{"applet"}->remove($child);
		}
		@children = ();

		my $eventbox = Gtk2::EventBox->new();
		$eventbox->add( $self->{"icon"} );
		$self->{"gnome"}->{"tooltip"} = Gtk2::Tooltips->new();
		$self->{"gnome"}->{"tooltip"}->enable();
		$self->{"gnome"}->{"tooltip"}->set_tip(  $eventbox , $self->{"text"} );
		$self->{"gnome"}->{"applet"}->add( $eventbox );
	}
	else
	{
		$self->{"gnome"}->{"label"}->set_label( $self->{"text"} );
	}
	$self->{"gnome"}->{"applet"}->show_all();
}


=head2 schedule

 $self->schedule();

Schedule the callbackusing Glib::Timeout

=cut

sub schedule
{
	my ( $self ) = @_;
	
	if( $self->{"frequency"} != -1 )
	{
		if($self->{"gnome"}->{"timeout"})
		{	
			Glib::Source->remove($self->{"gnome"}->{"timeout"}) 
		}
		$self->{"gnome"}->{"timeout"} = Glib::Timeout->add ( $self->{"frequency"} * 1000 , sub { $self->{"callback"}->( $self) } );

	}
}


=head2 _order

This specifies the priority used by SystemTray::Applet->new when loading plugin. Gnome is 2 as if it is installed we should probably use it.

=cut

sub _order
{
	return 2;
}

=head1 AUTHOR

Peter Sinnott, C<< <psinnott at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-systemtray-applet-gnome at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=SystemTray-Applet-Gnome>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SystemTray::Applet::Gnome


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=SystemTray-Applet-Gnome>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/SystemTray-Applet-Gnome>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/SystemTray-Applet-Gnome>

=item * Search CPAN

L<http://search.cpan.org/dist/SystemTray-Applet-Gnome>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Peter Sinnott, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of SystemTray::Applet::Gnome
