# Library Computer Access/Retrieval System (LCARS) for Starships!
### Sinatra portfolio project for the Flatiron School

## Overview
This app is like that awesome database Starfleet is always using in various StarTrek series.  Except that here, all users can view all the entries, as though maybe galactic peace was declared.  Of course, only the user that submitted an entry can modify or delete it (otherwise it would be too silly).

A user can enter information about a starship that any good intelligence agency would be interested in: class and sub-class, crew complement, top speed, and affiliation/empire.

Take it for a spin: https://starship-lcars.herokuapp.com/

## Installation
Fork and clone this repository, and then within the main directory execute
```
$ bundle install
$ rake db:migrate
```
Then run:
```
$ shotgun
```
Open up a new browser tab and navigate to:
```
localhost:9393
```

### Contributors
Contributions are welcome =]

### License
The full [MIT license](https://github.com/ddhogan/starship-LCARS/blob/master/LICENSE) can be found in this repo.
