# 🍋 Lemons Timing

This project was created after https://timing.71wytham.org.uk/ was forced to take his amazing live timing screen offline. 
You can load this with any JSON feed that fits the format 😉😉, if you look around the LEMONS site you can find it. 
Mind you, you might need a bit of technological knowledge to get it running. You can follow me on [twitter](https://twitter.com/marthyn) for help, send it through DM or email me at info@voxapex.nl

Create a .env file in the root of the project with `FEED_URL=someurl.json` or replace it in the [TimingsController](app/controllers/timings_controller.rb) file. 

To run the project make sure you can run any Ruby on Rails project https://gorails.com/setup

After installing everything you need you should be able to run rails server and go to [localhost:3000](localhost:3000) in your browser

Follow all the action at [RadioLemans](http://radiolemans.co)! Follow [RadioLemans](https://twitter.com/radiolemans) on twitter as well. 

### Setup (if you are able to run the newest version of Ruby on Rails)

```bash
git clone git@github.com:Marthyn/timing_lemons.git
cd timing_lemons
bundle timing_lemons
FEED_URL=look_for_this_on_wec_site rails server
```

### Settings

In [timings.coffee](app/assets/javascripts/timing.coffee) you can set some settings like blinking sector times or intervals when cars are close to eachother or settings times close to their fast times, you can also change the highlighted lines that i favorited.

## Coffee & Legal fees

If you want to pay for my coffee and Red Bull (or potential legal fees) for the 24 hours you can donate through paypal [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=XPL8633DZPCNU&currency_code=EUR&source=url)
