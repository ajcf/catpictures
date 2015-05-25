# catpictures

catpictures uses thecatapi.com's API to allow users to browse and favorite cat photos.
Users are able to browse by category, such as "space" or "hats", to find their favorite types of cat photos.

Additionally, users can favorite images they particularly like, or report images that are inappropriate (offensive, or do not contain cats).

# requirements

thecatapi runs on ruby 2.1, with sinatra 1.4. It has not been tested with other versions, however, it should be compatible with ruby 1.9+.

In addition, it uses the httparty gem to connect to thecatapi.com's API.

In order to install and run catpictures locally, you will need to request an API key [here](http://thecatapi.com/api-key-registration.html).

# installation

Installing should be as easy as 

```
# download the application:
git checkout https://github.com/ajcf/catpictures.git
cd catpictures

# install dependances
bundle

# create a config file
cp config/application.yml.sample config/application.yml
vim config/application.yml
# enter your own thecatapi.com API key for API_KEY and a random application secret string for SECRET

# start your server on `localhost:4567`:
ruby application.rb
```
