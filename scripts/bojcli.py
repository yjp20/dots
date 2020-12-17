#!/bin/python3

# pylint: disable=R,C

"""
Takes in filename, then submits that to acmicpc.net
Reads from configuration file at ~/.acmicpc.conf
"""

import argparse
import configparser
import os
import sys
import requests
from bs4 import BeautifulSoup as bs4
from termcolor import colored

CONFIG = os.path.expanduser('~/.acmicpc.conf')
LOGIN_URL = 'https://www.acmicpc.net/signin'
SUBMIT_URL = 'https://www.acmicpc.net/submit/'
STATUS_URL = 'https://www.acmicpc.net/status?'
STATUS_AJAX_URL = 'https://www.acmicpc.net/status/ajax'

EXT = {
    '.cpp': 88,
    '.txt': 58,
    '.py': 28,
}

RESULT_MAP = [
    'waiting...',
    'rejudging...',
    'compiling...',
    'judging...',
    'answer correct',
    'output error',
    'wrong answer',
    'time limit exceeded',
    'memory limit',
    'output length error',
    'runtime error',
    'compile error',
    'unavailable',
    'deleted',
    'compile',
    'partially accepted',
]

RESULT_COLOR = [
    'yellow',
    'yellow',
    'yellow',
    'yellow',
    'green',
    'red',
    'red',
    'red',
    'red',
    'red',
    'red',
    'red',
    'red',
    'red',
    'red',
    'red',
]

def _g(msg):
    return colored(msg, 'green')

def error(msg):
    print(colored(msg, 'red'))
    sys.exit(1)

def read_config():
    config = configparser.ConfigParser()
    config.read(CONFIG)
    if 'login' in config:
        return config
    else:
        config['login'] = {}
        config['login']['username'] = ''
        config['login']['password'] = ''
        with open(CONFIG, 'w') as f:
            config.write(f)
            print('enter usename and password into %s' % colored(CONFIG, 'cyan'))
            error('error: no configuration found, created one')

def get_arguments():
    ap = argparse.ArgumentParser()
    ap.add_argument('file', type=str)
    args = ap.parse_args()
    return os.path.splitext(args.file)

def get_problemid(base):
    if base.isdigit():
        return int(base)
    else:
        error('error: problem id not a valid number')

def get_language(ext):
    language = EXT.get(ext)
    if language:
        return language
    else:
        error('error: extension "%s" not a recognized language' % ext)

def read_source(filename):
    try:
        with open(filename, 'r') as f:
            data = f.read()
            f.close()
            return data
    except FileNotFoundError:
        error('error: file not found')

def login(username, password):
    payload = {
        'login_user_id': username,
        'login_password': password,
        'next': '/user',
        }

    session = requests.session()
    r = session.post(LOGIN_URL, data=payload)
    if username in r.text:
        print('login successful! :)')
        return session
    else:
        error('login failed :(')

def submit(session, problem_id, source, language):
    url = '%s%d' % (SUBMIT_URL, problem_id)
    print('submitting to: %s' % _g(url))
    r = session.get(url)
    soup = bs4(r.text, 'html.parser')
    csrf_key = soup.find('input', attrs={'name':'csrf_key'}).get('value')

    payload = {
        'problem_id': problem_id,
        'source': source,
        'language': language,
        'code_open': 'open',
        'csrf_key': csrf_key,
    }

    r = session.post(url, cookies=session.cookies, data=payload)

def get_updates(session, username, problem_id):
    url = '%suser_id=%s&problem_id=%d&from_mine=1' % (STATUS_URL, username, problem_id)
    r = session.get(url)
    soup = bs4(r.text, 'lxml')

    # get sumbission id
    table = soup.find('table', { 'id': 'status-table' })
    tbody = table.find('tbody')
    tr = tbody.find()
    solution_id = int(tr['id'][9:])
    print('submitted and watching id: #%s\n' %  _g(solution_id))

    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:28.0) Gecko/20100101 Firefox/28.0',
        'Accept': 'application/json, text/javascript, */*; q=0.01',
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'X-Requested-With': 'XMLHttpRequest',
    }

    payload = {
        'solution_id': solution_id,
    }

    while (1):
        r = session.post(
            STATUS_AJAX_URL,
            cookies=session.cookies,
            data=payload,
            headers=headers)

        solution = r.json()
        result = int(solution['result'])

        print('result: %s           \r' % colored(RESULT_MAP[result], RESULT_COLOR[result]), end='')
        if 4 <= result:
            print('')
            if result == 4:
                print('time: %s ms   mem: %s kb' % (_g(solution['time']), _g(solution['memory'])))
                break;
            else:
                sys.exit(1)

def main():
    print('\n\n # acmicpc submitter by Young Jin Park\n # <youngjinpark20@gmail.com>\n')
    config = read_config()
    print('user: %s' % _g(config['login']['username']))
    [base, ext] = get_arguments()
    problem_id = get_problemid(base)
    print('submitting problem: #%s' % (_g(problem_id)))
    language = get_language(ext)
    print('recognized ext: %s as %s' % (_g(ext), _g(language)))
    source = read_source('%d%s' % (problem_id, ext))
    session = login(config['login']['username'], config['login']['password'])
    submit(session, problem_id, source, language)
    get_updates(session, config['login']['username'], problem_id)

main()
