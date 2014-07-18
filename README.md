# Sinatra with SQL CRUD

We're building the next hot fish favoriting site; fish.ly. Google, Apple, IBM, and anyone who's anyone is entering this market; we have to move fast. For our MVP (Minimum Viable Product) the site needs to let users register, create fish, and favorite other people's fish. If this is shipped by the end of this week, we close a $20m round at a $300m valuation; just enough to feed our families!

Since someone decided that more engineers means more throughput, I've made the executive decision to have you all work in pairs and produce the same application 13 times. Of course, as your engineering manager, I know this isn't true, but hey who am I to disagree with the people writing the checks; you all have a job, so be thankful. When it's all said and done I'll tell 'em we all worked hard to produce a single version of their vision, but we all know Google's going to beat us anyways. I heard they have a fish favoriting watch or something.

Anyways, back to the application!

# Exercise

This web application will walk through a site complete with registration, login, fish creation, user interaction. You'll even be able to delete other users! Exciting!

Follow the mockups and stories to get started. The mockups only go through to user sign up and registration. Anything after that is up to you to decide how it looks, since we fired that guy because we didn't need him, obviously, and besides we all know engineers are pretty much designers anyways. Please add your tracker to your students submission.

## Getting started

1. `bundle install`
1. Import `stories.csv` into tracker.
1. Create a heroku app. `$ heroku create`
1. `$ cp config/database.yml.example config/database.yml` #
1. `$ rake db:create`
1. `$ rake db:migrate`
1. `$ RACK_ENV=test rake db:migrate`
1. Run rspec to check that it worked
1. Start a story
1. *Write a test!*
1. See the test fail for the _reason you expect_
1. Write implementation
1. Commit and push to GitHub
1. Push to Heroku
  * run migrations on heroku if necessary!
1. Finish and deliver story
1. Check heroku and bask in the glory of real software
1. Rinse and Repeat

http://floating-chamber-4723.herokuapp.com/


git add ignore bottom codes

        <!--<h1>Your Fish</h1>-->
        <!--<ul>-->
          <!--<% @database_connection.sql("SELECT * FROM fish WHERE user_id = '#{session[:user_id]}'").each do |fish| %>-->
            <!--<li><%= fish["name"] %> <%= fish["url"] %></li>-->
          <!--<% end %>-->
        <!--</ul>-->
        <!--<h1>Other User's Fish</h1>-->
        <!--<form action="/fish_list" method="post">-->
          <!--<select name="fish_list" id="fish_list">-->
            <!--<% @database_connection.sql(@order_user_string).each do |user| %>-->
              <!--<option value="<%=user["id"]%>"><%=user["username"]%></option>-->
            <!--<% end %>-->
          <!--</select>-->
          <!--<button type="submit">Check Fish</button>-->
        <!--</form>-->




        <!--<form action="/login" method="post"><button type="submit">Sort</button></form>-->