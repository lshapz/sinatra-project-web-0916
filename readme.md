### Sinatra Mini-Project

Time for another mini-project. Using the Yelp API, build a Sinatra web-app that allows you to add users and restaurants to your database and then choose which users want to visit which restaurant.

## Functionality
Watch the below clip to see basic functionality of app.

<img src="/gifs/BasicSinatraApp.gif">

- A user should be able to add a new user
- A user should be able to see all other users
- A user should be able to add a restaurant
- A user should be able to select a user and add it to a restaurant's list of users

## Domain Modeling
- What's the relationship between a user and a restaurant?
- What models and controllers will you need?
- Break up the controllers based on their responsibility

# Requests
- What type of requests will you use to create a new user and restaurant?
- What about seeing all users/restaurants and seeing individual users/restaurants
- In notes.md, write each type of request, the controller it hits, and action that deals with the request

When you've successfully built out an app that allows you to add a restaurant manually, add the Yelp API feature. We've included the Yelp gem. You'll need to login to get unique tokens at https://www.yelp.com/developers/documentation/v2/overview

<img src="/gifs/BasicSinatraAppwithAdapterPattern.gif">

Using the adapter pattern, allow your users to hit the API and get restaurant objects returned. Once your adapter pattern is working effectively, feel free to tool around with the API.

uses "shotgun" to start server
