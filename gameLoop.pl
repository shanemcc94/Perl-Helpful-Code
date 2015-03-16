#!/usr/bin/perl
use strict;
# Purpose: demonstrate basics of creating a game loop in
#       a graphics program using SDL. Program creates an App., creates a
#       rectangle, draws background in rectangle, starts a game loop which
#       reports mouse and keyboard events. 'x' or 'Q' to quit.

use SDL; #needed to get all constants
use SDL::Video;
use SDLx::App;
use SDL::Surface;
use SDL::Rect;
use SDL::Image;
use SDL::Event;
use SDL::Mouse;

my ($application, $background, $background_rect, $event, $exiting);
# First create a new App
$application = SDLx::App->new(
    title  => "Sample",
    width  => 800, # use same width as background image
    height => 600, # use same height as background image
    depth  => 32,
    exit_on_quit => 1 # Enable 'X' button
);
# Add event handler for quit (covered also by 'q' of 'x' from keyboard)
$application->add_event_handler( \&quit_event );
# Load an image for the background
# If the program is run without an available image the error
#  "Can't call method "w" on an undefined value at ThisFile.pl line XX."
# will be received.
$background = SDL::Image::load('duck.jpg');
# Create a rectangle for the background image
$background_rect = SDL::Rect->new(0,0,
    $background->w,
    $background->h,
);
# Create a new event structure variable
$event = SDL::Event->new();
# Draw the background
SDL::Video::blit_surface($background, $background_rect, $application, $background_rect );
# Update the window
SDL::Video::update_rects($application, $background_rect);

$exiting = 0;
# Start a game loop
while ( !$exiting ) {
  $application->update;
  # Update the queue to recent events
  SDL::Events::pump_events();
  # process all available events
  while (SDL::Events::poll_event($event)) {
    # check by Event type      
    if ($event->type == SDL_QUIT) {
      &quit_event(); 
    }
    elsif ($event->type == SDL_KEYUP) {
        &key_event($event);
    }
    elsif ($event->type == SDL_MOUSEBUTTONDOWN) {
      &mouse_event($event);
    }
  }
  SDL::Video::update_rects($application);
  # slow things down if required
  $application->delay(100);
} # game loop

sub quit_event {
	exit;
}

sub key_event {
  # printed output from here is going to the CLI
  print "Key is: ";
  my $key_name = SDL::Events::get_key_name( $event->key_sym );  
  print "[$key_name]\n";
  if (($key_name eq "q") || ($key_name eq "Q") ) {
    $exiting = 1;
  }
  if (($key_name eq "x") || ($key_name eq "X") ) {
    $exiting = 1;
  }
}

sub mouse_event {
  # printed output from here is going to the CLI
  print "Mouse: ";
  my ($mouse_mask,$mouse_x,$mouse_y)  = @{SDL::Events::get_mouse_state()};
  print "[$mouse_x, $mouse_y]\n";
}
