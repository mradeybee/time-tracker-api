# Time Tracker API

# End Points Functionalities
|End Point| Body Payload | Description  | Require Auth Token|
|:---------------------:|  :----:| :----:| :----:|
| **POST /users/** | email, password | Create User | false
| **POST /auth/login**| email, password | Login user | false
| **POST /auth/logout** | referesh_token | Log out user | true
| **POST /auth/refresh** | referesh_token | Refresh user auth token | true
| **POST /timer** | seconds, start_at, stop_at | Create Timer Record | true
| **GET /user_timers** | - | Fetches all timer records logged by a logged in user | true

___
[See Detailed Endpoints Documentation Here](https://t-tracker-api.herokuapp.com/)
___

# Running The Application

-  Clone or download the repo
```
git clone git@github.com:mradeybee/time-tracker-api.git
```

- Navigate to the app directory
```
cd time-tracker-api
```

- Bundle dependencies
```
bundle install
```

- Run Database setup
```
rails db:create && rails db:migrate
```

- Setup environment variables
```
export SECRET='<A SECRETE TOKEN>'
```

- Start the application
```
rails server
```
___

# Running Tests

The tests are run using RSpec.
```
rspec
```
