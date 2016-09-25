module MoviesDoc
  def self.superclass
    MoviesController
  end

  extend Apipie::DSL::Concern

  api :GET, '/v1/movies', 'Show list of the movies', version: '1'
  formats [:json]
  header 'X-User-Email', 'User email. Required if "user_email" param is blank.', required: true
  header 'X-User-Token', 'User authentication token. Required if "user_token" param is blank.', required: true
  param :user_email, String, desc: 'User email. Required if "X-User-Email" header is blank.', required: true
  param :user_token, String, desc: 'User authentication token. Required if "X-User-Token" header is blank.', required: true
  error '401', 'Unauthorized'
  example '"data":[
  {
    "type":"movies",
    "id":"57e64cdd19924e4efa30495f",
    "attributes":{
      "state":"done",
      "start-time":"00:00:01",
      "end-time":"00:00:05",
      "duration":4.024,
      "file":"/uploads/movie/file/57e64cdd19924e4efa30495f/test_example.mp4"
    },
    "links":{
      "self":"/v1/movies/57e64cdd19924e4efa30495f"
    }
  }
]'
  def index
    # Nothing here, it's just a stub
  end

  api :GET, '/v1/movies/:id', 'Show user movie.', version: '1'
  formats [:json]
  header 'X-User-Email', 'User email. Required if "user_email" param is blank.', required: true
  header 'X-User-Token', 'User authentication token. Required if "user_token" param is blank.', required: true
  param :user_email, String, desc: 'User email. Required if "X-User-Email" header is blank.', required: true
  param :user_token, String, desc: 'User authentication token. Required if "X-User-Token" header is blank.', required: true
  param :id, String, desc: 'Movie id.', required: true
  error '401', 'Unauthorized'
  error '404', 'Not Found'
  example '"data":
  {
    "type":"movies",
    "id":"57e64d2019924e4f14f06ca1",
    "attributes":{
      "state":"done",
      "start-time":"00:00:01",
      "end-time":"00:00:05",
      "duration":4.024,
      "file":"/uploads/movie/file/57e64d2019924e4f14f06ca1/test_example.mp4"
    },
    "links":{
      "self":"/v1/movies/57e64d2019924e4f14f06ca1"
    }
  }'
  def show
    # Nothing here, it's just a stub
  end

  api :POST, '/v1/movies', 'Create movie.', version: '1'
  formats [:json]
  header 'X-User-Email', 'User email. Required if "user_email" param is blank.', required: true
  header 'X-User-Token', 'User authentication token. Required if "user_token" param is blank.', required: true
  param :user_email, String, desc: 'User email. Required if "X-User-Email" header is blank.', required: true
  param :user_token, String, desc: 'User authentication token. Required if "X-User-Token" header is blank.', required: true
  param :movie, Hash, required: true do
    param :start_time, String, desc: 'Start time for video trimming. Needs to be less than end_time param.', required: true
    param :end_time, String, desc: 'End time for video trimming. Needs to be greater than start_time param.', required: true
    param :file, File, desc: 'Video file for trimming.', required: true
  end
  error '401', 'Unauthorized'
  error '422', 'Unprocessable entity'
  example 'Success:
{
  "data": {
    "type": "movies",
    "id": "57e6545719924e50f4fdad24",
    "attributes": {
      "state": "scheduled",
      "start-time": "00:00:01",
      "end-time": "00:00:06",
      "duration": null,
      "file": null
    },
    "links": {
      "self": "/v1/movies/57e6545719924e50f4fdad24"
    }
  }
}'
  example 'Errors:
{
  "errors": [
    {
      "source": {
        "pointer": "/data/attributes/file"
      },
      "detail": "File can\'t be blank"
    },
    {
      "source": {
        "pointer": "/data/attributes/start-time"
      },
      "detail": "Start time can\'t be blank"
    },
    {
      "source": {
        "pointer": "/data/attributes/end-time"
      },
      "detail": "End time can\'t be blank"
    },
    {
      "source": {
        "pointer": "/data/attributes/start-time"
      },
      "detail": "Start time can\'t be greater than end time"
    }
  ]
}'
  def create
    # Nothing here, it's just a stub
  end

  api :PUT, '/v1/movies/:id', 'Restart failed movie.', version: '1'
  formats [:json]
  header 'X-User-Email', 'User email. Required if "user_email" param is blank.', required: true
  header 'X-User-Token', 'User authentication token. Required if "user_token" param is blank.', required: true
  param :user_email, String, desc: 'User email. Required if "X-User-Email" header is blank.', required: true
  param :user_token, String, desc: 'User authentication token. Required if "X-User-Token" header is blank.', required: true
  param :id, String, desc: 'Movie id.', required: true
  error '401', 'Unauthorized'
  error '422', 'Unprocessable entity'
  error '404', 'Not found'
  example 'Success:
{
  "data": {
    "type": "movies",
    "id": "57e7cd43f6f82d525749cbaa",
    "attributes": {
      "state": "scheduled",
      "start-time": "00:00:01",
      "end-time": "00:00:05",
      "duration": null,
      "file": null
    },
    "links": {
      "self": "/v1/movies/57e7cd43f6f82d525749cbaa"
    }
  }
}'
  example 'Errors:
{
  "errors": [
    {
      "source": {
        "pointer": "/data/attributes/state"
      },
      "detail": "State cannot transition via \"restart\""
    }
  ]
}

{
  "errors": [
    {
      "detail": "Document(s) not found for class Movie with id(s) nonexistent-record-id."
    }
  ]
}'
  def update
    # Nothing here, it's just a stub
  end

  api :DELETE, '/v1/movies/:id', 'Delete failed movie.', version: '1'
  formats [:json]
  header 'X-User-Email', 'User email. Required if "user_email" param is blank.', required: true
  header 'X-User-Token', 'User authentication token. Required if "user_token" param is blank.', required: true
  param :user_email, String, desc: 'User email. Required if "X-User-Email" header is blank.', required: true
  param :user_token, String, desc: 'User authentication token. Required if "X-User-Token" header is blank.', required: true
  param :id, String, desc: 'Movie id.', required: true
  error '401', 'Unauthorized'
  error '404', 'Not Found'
  example 'Errors:
{
  "errors": [
    {
      "detail": "Document(s) not found for class Movie with id(s) nonexistent-record-id."
    }
  ]
}'
  def destroy
    # Nothing here, it's just a stub
  end
end