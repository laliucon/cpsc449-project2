import sys
import textwrap
import sqlite3

import bottle
from bottle import get, post, error, abort, request, response, HTTPResponse
from bottle.ext import sqlite

# Set up app, plugins, and logging
#
app = bottle.default_app()
app.config.load_config('./timelines.ini')

plugin = sqlite.Plugin(app.config['sqlite.dbfile'])
app.install(plugin)



# Return errors in JSON
#
# Adapted from # <https://stackoverflow.com/a/39818780>
#
def json_error_handler(res):
    if res.content_type == 'application/json':
        return res.body
    res.content_type = 'application/json'
    if res.body == 'Unknown Error.':
        res.body = bottle.HTTP_CODES[res.status_code]
    return bottle.json_dumps({'error': res.body})


app.default_error_handler = json_error_handler

# Disable warnings produced by Bottle 0.12.19.
#
#  1. Deprecation warnings for bottle_sqlite
#  2. Resource warnings when reloader=True
#
# See
#  <https://docs.python.org/3/library/warnings.html#overriding-the-default-filter>
#
if not sys.warnoptions:
    import warnings
    for warning in [DeprecationWarning, ResourceWarning]:
        warnings.simplefilter('ignore', warning)


# Simplify DB access
#
# Adapted from
# <https://flask.palletsprojects.com/en/1.1.x/patterns/sqlite3/#easy-querying>
#
def query(db, sql, args=(), one=False):
    cur = db.execute(sql, args)
    rv = [dict((cur.description[idx][0], value)
          for idx, value in enumerate(row))
          for row in cur.fetchall()]
    cur.close()

    return (rv[0] if rv else None) if one else rv


def execute(db, sql, args=()):
    cur = db.execute(sql, args)
    id = cur.lastrowid
    cur.close()

    return id

#Routes

@get('/users/<username>/userTimeline')
def userTimeline(db,username):
    timeline = query(db, 'SELECT * FROM posts where user_id = ? ORDER BY timestamp DESC LIMIT 25',[username])
    response.content_type = 'application/json'
    return timeline

@get('/publicTimeline')
def publicTimeline(db):
    timeline = query(db, 'SELECT * FROM posts ORDER BY timestamp DESC LIMIT 25')
    response.content_type = 'application/json'
    return timeline

@get('/users/<username>/homeTimeline')
def homeTimeline(db,username):
    timeline = query(db,'SELECT * FROM posts WHERE username IN (SELECT userToFollow FROM username WHERE username=?) ORDER BY timestamp DESC LIMIT 25',[username])
    response.content_type = 'application/json'
    return timeline

@post('/users/<username>/posts')
def post(db,username):

    text = request.forms.get('text')
    timestamp = datetime.utcnow()
    post = execute(db,'INSERT INTO posts(username,text,timestamp) VALUES (:username,:text,timestamp)', posts)
    response.content_type = 'application/json'
    return post
        
    


