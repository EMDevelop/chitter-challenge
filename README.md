# ~~Twitter~~ Chitter Chatter

## About

This application was built as a clone of Twitter, although it has the functionality of a chatroom.

The project was built over a weekend, planned and modelled on Friday and then executed on Saturday and Sunday.

I mainly enjoyed learning how to store passwords securely (using Becrypt with SALT and PEPPER hashing), while also building everything with SRP/Encapsulation/Separation of concerns in mind.

Also, the app has 100% TDD coverage.

---

## Functionality

#### Post messages

![](https://github.com/EMDevelop/public_resources/blob/main/gifs/Chitter/gifs/post.gif)

#### Post replies to posted messages

![](https://github.com/EMDevelop/public_resources/blob/main/gifs/Chitter/gifs/reply.gif)

#### Sign Up, as a new user

![](https://github.com/EMDevelop/public_resources/blob/main/gifs/Chitter/gifs/signup.gif)

#### Sign In, but only with correct credentials

![](https://github.com/EMDevelop/public_resources/blob/main/gifs/Chitter/gifs/signin.gif)

#### Sign out, no access unless signed in

![](https://github.com/EMDevelop/public_resources/blob/main/gifs/Chitter/gifs/logout.gif)

---

## How To Run

##### General Setup

- You must have a version of `Ruby` installed on your computer (`brew install ruby`), I used `v 2.7.2`
- You will need to have an instance of `PostgreSQL`
- In your Terminal:
  - Run `git clone https://github.com/EMDevelop/chitter-challenge.git`
  - For Ruby specific dependencies, run `bundle install`
  - Run `rackup` in your terminal to spin up a local server (default port 9292)
  - Visit http://localhost:9292/ to test drive the application

---

## My Approach

##### Setup

- This project is a fork of `https://github.com/makersacademy/chitter-challenge`
- Understand the `User Stories`
- Create `Domain Models` from the User Stories
- Setup a basic layout for the app with `MVC` mapped out
- Install a testing framework for unit tests (RSpec) and Capybara for feature tests.
- Creating a new Database
  - Using `Postgres`, you can see all scripts used within `db/migrations`
- Create a new Test database
- ADD `.env` to `.gitignore`
- Setup DB classes
  - Create a spec file and test for connection
  - Create a class to make and hold connection
  - Create a helper file to auto connect in spec_helper and app.rb on load

---

##### User Stories

```
As a Maker
So that I can let people know what I am doing
I want to post a message (peep) to chitter

As a maker
So that I can see what others are saying
I want to see all peeps in reverse chronological order

As a Maker
So that I can better appreciate the context of a peep
I want to see the time at which it was made

As a Maker
So that I can post messages on Chitter as me
I want to sign up for Chitter

As a Maker
So that only I can post messages on Chitter as me
I want to log in to Chitter

As a Maker
So that I can avoid others posting messages on Chitter as me
I want to log out of Chitter

As a Maker
So that I can stay constantly tapped in to the shouty box of Chitter
I want to receive an email if I am tagged in a Peep

As A Maker
So that I can start conversations
I want to be able to reply to peoples messages

As a Maker
So that I can see what people said to me
I want to be able to see replies
```

##### Domain Model

`className = Chitter`
|methods |attributes|
|-|-|
|Chitter.show_all_messages() | |
|Chitter.add_message() | |
|Chitter.sign_up() | |

`className = Message`
|methods |attributes|
|-|-|
| .new() | @message :String|
| | @id :String|
| | @create_date :String|

`className = User`
|methods |attributes|
|-|-|
| | @user_name |
| | @email |
| | @id |

`className = Reply < Message`
|methods |attributes|
|-|-|
| | @message_id |

##### Database Model

###### Tables

`Table: Message`
|ID|ID_USERS|message|create_date|
|-|-|-|-|
|BIGSERIAL NOT NULL PRIMARY KEY|INT NOT NULL REFERENCES users(ID)|VARCHAR(200)|TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP|

`Table: Users`
|ID|user_name|password|email|salt|
|-|-|-|-|-|
|BIGSERIAL NOT NULL PRIMARY KEY|VARCHAR(30)|VARCHAR(30)|TEXT|TEXT|

`Table: Replies`
|ID|ID_USERS|ID_MESSAGE|message|create_date|
|-|-|-|-|-|
|BIGSERIAL NOT NULL PRIMARY KEY|INT NOT NULL REFERENCES users(ID)|INT NOT NULL REFERENCES messages(ID)|VARCHAR(200)|TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP|

###### Relationships

| table   | relationship | table |
| ------- | ------------ | ----- |
| Message | 1 - 1        | Users |

## General Sinatra / Capybara Setup

```
mkdir app
cd app
touch app.rb
mkdir views
cd views
touch index.erb
..
..
mkdir db
cd db
mkdir migrations
cd migrations
touch 01_create_bookmarks.sql
..
..
mkdir lib

cd spec
mkdir feature
cd feature
touch feature_spec.rb
touch feature_helper.rb
..
..
touch .gitignore
touch .env
touch config.ru
```

## Questions

- Why do we have the view in the app folder with the model, is this a violation of a "separation of concerns"?

- Am I right to include the Database Connection class within the DB folder under a Queries directory? or should that be with the rest of the model in `lib`?

- In the `postgres_db_spec.rb` on the test `it 'stores connection'` I had to use a hook to not run the before in the `spec_helper` on that hook (I left a comment there). For some reason with this test here, I get the error

```
  1) PGDatabase make connection stores connection
     Failure/Error: PGDatabase.con.exec("TRUNCATE message;")

     NoMethodError:
       private method `exec' called for nil:NilClass
     # ./spec/feature/feature_helper.rb:3:in `fill_data'
     # ./spec/spec_helper.rb:34:in `block (2 levels) in <top (required)>'
```

- Had a bit of a nightmare with the `pg_connection.rb`, I had to wrap it in a module and call it after I set the env variable. I think the `ENV['ENVIRONMENT']` was being called after the `require_relative '../db/queries/pg_connect'` ran in the `spec_helper.rb` ? see my prints `p env is?`.

- Should I be setting the timestamp in the Database using `CURRENT_TIMESTAMP` or should this be done on the front end?

- Should you store pepper (for password encryption) in a .env var?

- In your ORM example, where you use the DatabaseConnection object to write a custom string, I thought the point of ORM was to remove any SQL from the Object its self? (aka in this case, the Users class), becuase the SQL for MYsql might be different for Postgres, so with the below, we'd need to edit the User class when really we'd only want to edit the DatabaseConnection class? would it not be something like `DatabaseConnection.create_user(email,password)` ? Query:

```
# from https://github.com/makersacademy/course/blob/main/bookmark_manager/walkthroughs/19.md
    result = DatabaseConnection.query(
      "INSERT INTO users (email, password) VALUES($1, $2) RETURNING id, email;",
      [email, password]
    )
```

- I had issues with the flash notice, is this normal? from the documentation it looks like this is only RAILS?
  https://api.rubyonrails.org/classes/ActionDispatch/Flash.html

```
2021-09-19 12:37:06 - NameError - undefined local variable or method `flash' for #<ChitterApp:0x00000001039aae80>:
```
