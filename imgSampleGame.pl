#!/usr/bin/perl
use strict;
# Purpose: demonstrate basics of displaying a sequence of different sized
#       images in a fixed size rectangle, scaling the images up or down as required.
#       Use leftarraow and rightarrow to sequence thru the images.
#       Also reports mouse and keyboard events. 'x' or 'Q' to quit.
#       You'll need to provide 4 image files.


use SDL; #needed to get all constants
use SDL::Video;
use SDLx::App;
use SDL::Surface;
use SDL::Rect;
use SDL::Image;
use SDL::Event;
use SDL::Mouse;
use SDLx::Text;
use SDL::GFX::Rotozoom;

my ($window, $back, $back_rect, $event, $exiting, $front, $front_rect, $item_x, $item_y, $dest_rect, $front_h, $front_w);
my (@pictures, $filename, $text_box, $counter, $max, $target_width, $target_height, $angle, $zoom_x, $zoom_y, $squashed);

# First create a new SDLx:App
$window = SDLx::App->new(
    title  => "Image Sample.pl",
    width  => 800, # use same width as background image
    height => 600, # use same height as background image
    depth  => 32,
    exit_on_quit => 1 # Enable 'X' button
);
# Add event handler for quit (covered also by 'q' of 'x' from keyboard)
$window->add_event_handler( \&quit_event );
# Load an image for the background
# If the program is run without an available image the error
#  "Can't call method "w" on an undefined value at ThisFile.pl line XX."
# will be received. If you get this error you should try the
# steps at http://www.fachtnaroe.com/help/sdl_image_load_error.shtml

#put an image file name here for the background
$filename="duck.jpg";
&test_exists($filename);
$back = SDL::Image::load($filename);
&test_loading($back, $filename);
# Create a rectangle for the background image
$back_rect = SDL::Rect->new(0,0,
    $back->w,
    $back->h,
);
# Create a new event structure variable
$event = SDL::Event->new();
# Draw the background
SDL::Video::blit_surface($back, $back_rect, $window, $back_rect );

# Now load image data for a foreground item
$filename = "duck.jpg";
&test_exists($filename);
$front = SDL::Image::load($filename);
&test_loading($front, $filename);
# then store it for a while
push @pictures, $front;
# and again
$filename = "bird.jpg";
&test_exists($filename);
$front = SDL::Image::load($filename);
&test_loading($front, $filename);
# and store it for a while
push @pictures, $front;
# one more for the demo
$filename = "bird.jpg";
&test_exists($filename);
$front = SDL::Image::load($filename);
&test_loading($front, $filename);
# store it with the others
push @pictures, $front;
# keep track
$max = scalar @pictures; # scalar gives array element count

# set size for fixed size display box
$target_width = 400;
$target_height = 300;

# Add in a text box/location; we'll put text in it later
$text_box = SDLx::Text->new(size=>'24', # font can also be specified
                            color=>[255,0,0], # [R,G,B]
                            x =>10,
                            y=> 10);
# this is how to change color on a pre-existing text box
$text_box->color([150,10,90]);
# set key repeat on after 500ms, then every 100ms
SDL::Events::enable_key_repeat(500, 100 );
# Start a game loop
$exiting = 0;
while ( !$exiting ) {
  $window->update;
  # Update the queue to recent events
  SDL::Events::pump_events();
  # process all available events
  while (SDL::Events::poll_event($event)) {
  
    # check by Event type      
    if ($event->type == SDL_QUIT) {
      &quit_event(); 
    }
    elsif ($event->type == SDL_KEYDOWN) {
        &key_event($event);
        SDL::Video::blit_surface($back, $back_rect, $window, $back_rect);
        # we could rotate, but won't this time
        $angle = 0;
        # calculate x zoom factor as (target rectangle width)/(image width)
        $zoom_x = $target_width/$pictures[$counter-1]->w;
        # calc. y zoom as (target rectangle height)/(image height)
        $zoom_y = $target_height/$pictures[$counter-1]->h;
        # call rotozoom to squash the image
        # $pictures[$counter-1] represents the current image from the set stored at the start
        $squashed = SDL::GFX::Rotozoom::surface_xy( $pictures[$counter-1], $angle, $zoom_x, $zoom_y, SMOOTHING_ON );
        SDL::Video::blit_surface( $squashed, SDL::Rect->new(0, 0, $target_width, $target_height), 
                                  $window,  SDL::Rect->new(200, 150, 0, 0) );        
        $text_box->write_to($window,"Image: #[$counter] Zoom: X[$zoom_x] Y[$zoom_y]");
    }
    elsif ($event->type == SDL_MOUSEBUTTONDOWN) {
      &mouse_event($event);
    }
  }
  
  SDL::Video::update_rects($window);
  # slow things down if required
  $window->delay(100);
} # game loop

sub quit_event {
	exit;
} # sub quit

sub key_event {
  # printed output from here is going to the CLI
  my $key_name = SDL::Events::get_key_name( $event->key_sym );  
  if (($key_name eq "q") || ($key_name eq "Q") ) {
    $exiting = 1;
  }
  elsif (($key_name eq "x") || ($key_name eq "X") ) {
    $exiting = 1;
  }
  # increment/decrement picture counter
  elsif ($key_name eq "left") {
    $counter--;
    if ($counter < 1) {
      $counter = $max;
    }
  }
  elsif ($key_name eq "right") {
    $counter++;
    if ($counter > $max) {
      $counter = 1;
    }
  }
} # sub keyboard

sub mouse_event {
} # sub mouse

sub test_exists {
  # check if file exists
  my $image_file_name = $_[0];
  if (!(-e $image_file_name)) {
    print "File $image_file_name doesn't exist.\n";
    exit;
  }  
} # sub exists

sub test_loading {
  # see if there was an SDL error loading the image
  my ($image_data, $image_name) = @_;
  if (!$image_data) {
    my $error = SDL::get_error;
    print "SDL Error loading image ($image_name): $error\n";
    exit;
  }
}
