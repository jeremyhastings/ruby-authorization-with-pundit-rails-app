# Rails 6 Simple Pundit Authorization Application

This project is a demonstration of a Rails 6 application with Devise for authentication and Pundit for authorization.  In addition, a simple implementation of Bootstrap being installed into Webpack using Yarn.

## Getting Started

These instructions will allow you to make a copy of the project yourself, and get it up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

RubyMine 2019.3, Ruby 2.6.6, and Rails 6.0.2.2 were used to initially make this project on a machine with PostgreSql installed locally.  The application was created as minimalistically as possible.  SQLite should work as well as any other database 

## Creating

Create the rails project on your system.  If you are trying PostgreSql for the first time you may need to execute in the terminal:

```
rails db:create
```

followed by:

```
rails db:migrate
```

If you run the server you should be able to visit localhost:3000 at this point.

### Install Bootstrap

In the Terminal:

```
yarn add bootstrap jquery popper.js
```
Update config > webpack > environment.js:

```
const { environment } = require('@rails/webpacker')

const webpack = require("webpack")
environment.plugins.append("Provide", new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
}))

module.exports = environment
```

Update app > javascript > packs > application.js:

```
import "bootstrap";
```

Create app > javascript > stylesheets > application.scss:

```
@import "bootstrap";
```

Update app > views > layouts > application.html.erb:

```
<%= stylesheet_link_tag ... %>
```
to
```
<%= stylesheet_pack_tag ... %>
```

Update app > javascript > packs > application.js:

```
import "../stylesheets/application";
```

Create app > javascript > packs > custom.js:

```
// For Bootstrap //////////////////////////
$(function() {
    $('[data-toggle="tooltip"]').tooltip();
});

$(function() {
    $('[data-toggle="popover"]').popover();
});
// For Bootstrap //////////////////////////
```

Update app > javascript > packs > application.js:

```
import "./custom";
```

### Install Devise

Update Gemfile

```
# Use Devise for Authentication
gem 'devise'
```

In Terminal:

```
bundle install
```

In Terminal:

```
rails generate devise:install
```

In Terminal:

```
rails generate devise User
```

In Terminal:

```
rails db:migrate
```

### Create Articles

In Terminal:

```
rails generate scaffold Articles title body:text
```

In Terminal:

```
rails db:migrate
```

In Terminal:

```
rails generate migration add_user_id_to_articles user:references
```

In Terminal:

```
rails db:migrate
```

Update app > models > user.rb:

```
has_many :articles
```

Update app > models > article.rb:

```
belongs_to :user
```

### Install Pundit

Update Gemfile

```
# Use Pundit for Authorisation
gem 'pundit'
```

In Terminal:

```
bundle install
```

Update app > controllers > application.rb:

```
class ApplicationController < ActionController::Base
  include Pundit
end
```

In Terminal:

```
rails generate pundit:install
```

Create app > policies > article_policy.rb:

```
class ArticlePolicy < ApplicationPolicy

  def index?
    true # Anyone can look
  end

  def show?
    user.present? # Only logged in user
  end

  def create?
    user.present? # Only logged in user
  end

  def new
    create?
  end

  def update?
    return true if user.present? && user == article.user # If there is a logged in user and that user is the article owner
  end

  def edit?
    update?
  end

  def destroy?
    return true if user.present? && user == article.user # If there is a logged in user and that user is the article owner
  end

  private
  def article
    record
  end

end
```

Update app > controllers > articles_controller.rb:
(authorize @articles for every action)
:show, :edit, :update, and :destroy are done with set_article method.

```
def set_article
  @article = Article.find(params[:id])
  authorize @article
end
```

then

```
def index
  @articles = Article.all
  authorize @articles
end
  
def new
  @article = Article.new
  authorize @article
end

def create
  @article = Article.new(article_params)
  @article.user = current_user
  authorize @article   
  
  ...
end
```

Update app > controllers > application_controller.rb:

```

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:warning] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
  
```

## Running the tests

Tests to come at a later date.  Want to write some?

## Deployment

Should easily deploy to Heroku.  Instructions for that at a later date if needed.

## Built With

* [Ruby](https://www.ruby-lang.org/en/) - Language
* [Ruby on Rails](https://rubyonrails.org) - MVC Framework
* [RubyMine](https://www.jetbrains.com/ruby/) - IDE
* [PostgreSQL](https://www.postgresql.org) - Database
* [Devise](https://github.com/heartcombo/devise) - Authentication Gem
* [Pundit](https://github.com/varvet/pundit) - Authorization Gem
* [Bootstrap](https://getbootstrap.com) - Web Framework

## Contributing

If you want to ...

## Authors

* **Jeremy Hastings** - *Initial work* - [Jeremy Hastings](https://github.com/jeremyhastings/)

## License

This project is licensed under the GNU General Public License 3.0 License - see the [LICENSE.md](LICENSE.md) file for details
