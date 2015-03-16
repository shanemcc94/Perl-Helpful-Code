#!/usr/bin/perl
use strict;
# Purpose: demonstrate basics of displaying an image on a background, and then 
#       re-drawing at a new location;
#       This is a graphics program using SDL. Program creates an App., creates a
#       rectangle, draws background in rectangle, draws an image on the background
#       starts a game loop which re-draws the foreground image at the mouse (x,y)
#       Also reports mouse and keyboard events. 'x' or 'Q' to quit.


use SDL; #needed to get all constants
use SDL::Video;
use SDLx::App;
use SDL::Surface;
use SDL::Rect;
use SDL::Image;
use SDL::Event;
use SDL::Mouse;

my ($screen, $back, $back_rect, $event, $exiting, $front, $front_rect, $item_x, $item_y, $dest_rect, $front_h, $front_w);
# First create a new App
$screen = SDLx::App->new(
    title  => "Put a Window title here",
    width  => 800, # use same width as background image
    height => 600, # use same height as background image
    depth  => 32,
    exit_on_quit => 1 # Enable 'X' button
);
# Add event handler for quit (covered also by 'q' of 'x' from keyboard)
$screen->add_event_handler( \&quit_event );
# Load an image for the background
# If the program is run without an available image the error
#  "Can't call method "w" on an undefined value at ThisFile.pl line XX."
# will be received.

#put an image file name here
$back = SDL::Image::load('Games Sample 03');
# Create a rectangle for the background image
$back_rect = SDL::Rect->new(0,0,
    $back->w,
    $back->h,
);
# Create a new event structure variable
$event = SDL::Event->new();
# Draw the background
SDL::Video::blit_surface($back, $back_rect, $screen, $back_rect );

# Now load image data for a foreground item
$front = SDL::Image::load('bird.jpg');
# Put the image at the location X, Y which is top left
# Initially this will be 0,0
$item_x = 0;
$item_y = 0;
$front_w = $front->w;
$front_h = $front->h;
$front_rect = SDL::Rect->new($item_x,$item_y,$front_w,$front_h,);
    
# Draw the image
SDL::Video::blit_surface ($front, $front_rect, $screen, $front_rect);
# Update the window
SDL::Video::update_rects($screen);
$exiting = 0;
# Start a game loop
while ( !$exiting ) {
  $screen->update;
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
      $dest_rect = SDL::Rect->new(
        $item_x,
        $item_y,
        $front_w,
        $front_h);      
      # re-draw the background 
      SDL::Video::blit_surface($back, $back_rect, $screen, $back_rect );
      # Now draw the object in the new location
      SDL::Video::blit_surface($front, $front_rect, $screen, $dest_rect );
    }
  }
  SDL::Video::update_rects($screen);
  # slow things down if required
  $screen->delay(100);
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
  # We're not just printing the mouse (x,y), we're going to use it later
  $item_x = $mouse_x; 
  $item_y = $mouse_y;
}
