# Introduction

Rails web site allows to sort entered laptop by CPU,GPU ratings and price.

CPU ratings are taken from <https://www.notebookcheck.net/Mobile-Processors-Benchmark-List.2436.0.html?&deskornote=2&or=0&cpu_fullname=1&cores=1&threads=1>

GPU ratings are taken from <https://www.notebookcheck.net/Mobile-Graphics-Cards-Benchmark-List.844.0.html?multiplegpus=1&or=0&gpu_fullname=1>

Technology stack:

Ruby, Ruby on Rails, PostgreSQL, Redis, Puma, HAML, SASS, Bootstrap, jQuery, CoffeeScript, Turbolinks, Twitter Typeahead, HTML, CSS, Heroku, RuboCop, Uglifier, Levenshtein, Yarn

## How tools are used

- **Ruby**: Core programming language.
- **Ruby on Rails**: Main web application framework used to build the project.
- **PostgreSQL**: Primary relational database for data storage.
- **Redis**: Key-value store used by Rails for caching or session storage (`redis-rails`).
- **Puma**: Concurrent web server used in development and production environments.
- **HAML**: Templating engine for writing concise HTML views.
- **SASS**: CSS preprocessor used for more maintainable stylesheets.
- **Bootstrap**: Frontend framework for responsive layout and UI components.
- **jQuery**: JavaScript library for DOM manipulation and client-side logic.
- **CoffeeScript**: Scripting language compiling to JavaScript, used for frontend scripting.
- **Turbolinks**: Library that speeds up web page navigation by replacing the body without a full page reload.
- **Twitter Typeahead**: JavaScript library for search input auto-completion.
- **HTML & CSS**: Standard markup and styling languages for the web.
- **Heroku**: Cloud platform used to host and deploy the live application.
- **RuboCop**: Ruby static code analyzer and code formatter ensuring code quality.
- **Uglifier**: JavaScript minifier/compressor used in the Rails asset pipeline.
- **Levenshtein**: C-extension for calculating string distances, useful for fuzzy matching laptop hardware names.
- **Yarn**: Package manager for JavaScript dependencies.

Live site examples:

- <http://choose-best-laptop.herokuapp.com/>
- <http://choose-best-laptop.herokuapp.com/laptops/index?q=07464af51339050c91efbb2d6c0eaf41>
