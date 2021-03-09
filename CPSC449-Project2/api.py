#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar  5 17:29:41 2021

@author: hungcun
"""


import sys
import textwrap
import logging.config
import sqlite3

import bottle
from bottle import get, post, error, abort, request, response, HTTPResponse
from bottle.ext import sqlite

# Set up app, plugins, and logging
#
app = bottle.default_app()
app.config.load_config('./api.ini')

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
    
#signUp
    
@post('/users') 
def signUp(db):
    users = request.json

    username = request.forms.get('username')
    password = request.forms.get('password')
    email = request.forms.get('email')
    if not users:
        abort(400,f'All fields are required')
        return False
    try:
        execute(db,'INSERT INTO users(username, email, password) VALUES(:username, :email, :password)', users)
    except sqlite3.IntegrityError:
        abort(409, f'username or email has been taken')
        return False
    response.status = 201
    response.content_type = 'application/json'
    return True

@post('/users/<username>')
def authenticate(db, username):
    password = request.forms.get('password')

    db_password = query(db, 'SELECT password FROM users WHERE username = :username', users, one= True)
    if (password == db_password):
        response.status = 200
        response.headers['Content-Type'] = 'application/json'
        return True
    else:
        abort(401)
        return False

@post('/users/<username>/followers/')
def follow(db,username):
    followers = request.json
    userToFollow = request.forms.get('following_id')
    
    followers = execute(db, 'INSERT INTO followers(username,userToFollow) VALUES (:username, :userToFollow)',followers)
    response.content_type = 'application/json'
    response.status = 200
    return {'followers': followers}



@delete('users/<username>/followers/')
def unfollow(db,username):
    followers = request.json
    userToRemove = request.forms.get('userToFollow')
    followers[id] = execute(db, 'DELETE FROM followers WHERE id = ? AND follower_id = ? ', [id,follower_id])