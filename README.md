# Rails 6 Simple Pundit Authorization Application

This project is a demonstration of a Rails 6 application with Devise for authentication and Pundit for authorization.  In addition, a simple implementation of Bootstrap being installed into Webpack using Yarn.

## Getting Started

These instructions will allow you to make a copy of the project yourself, and get it up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

RubyMine 2019.3, Ruby 2.6.6, and Rails 6.0.2.2 were used to initially make this project on a machine with PostgreSql installed locally.  The application was created as minimalistically as possible.  SQLite should work as well as any other database 

### Creating

Create the rails project on your system.  If you are trying PostgreSql for the first time you may need to execute in the terminal:

```
rails db:create
```

followed by:

```
rails db:migrate
```

If you run the server you should be able to visit localhost:3000 at this point.

## Install Bootstrap

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

## Install Devise

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

## Create Articles

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

## Install Pundit

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

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
