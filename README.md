# ban-ku

## To run locally
  * Create your database instance in Docker with `docker-compose up`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## To call deployed server on heroku
[`https://ban-ku.herokuapp.com`](https://ban-ku.herokuapp.com)
(due to free tier some dynamos may take a while to awake)

## Available routes
[see complete documentation](routes.md)
|     |                       |
|-----|:---------------------:|
|POST | /api/v1/sign_in       |
|GET  | /api/v1/accounts      |
|GET  | /api/v1/accounts/:id  |
|POST | /api/v1/accounts      |
|POST | /api/v1/withdraw      |
|POST | /api/v1/transfer      |
|GET  | /api/v1/transactions  |
|GET  | /api/v1/report        |

## To deploy
heroku containers already build and deploy or docker file, all we need is to push the version we want to deploy to heroku
[`(sadly I didn't had time to configure a CI/CD)`](https://i.gifer.com/jR.gif)

## FAQ
* **How users sign up?**
```
Currenly the only way to create a backoffice user is manually on db or adding to project seeds
```
* **All actions must be perfomed by a backoffice user?**
```
Yes, I thought about this system being used for bank cashiers only
```
* **About the inconcistency on test comments**
```
A lot of code about index/get/update/... was auto generated with `mix phx.gen.json` and `mix phx.new` and left as is. Ideally, changes should be made so the general code style is consistent, including those files
```
