#!/bin/python3

# pylint: disable=R,C

"""
takes in problem as argument, then gets the input into the in folder within the
current directory and the outputs to the out directory.
"""

import argparse
import requests
import re
import os
from termcolor import colored
from bs4 import BeautifulSoup as bs4

URL = 'https://www.acmicpc.net/problem/'

def _g(msg):
    return colored(msg, 'green')

def get_arguments():
    ap = argparse.ArgumentParser()
    ap.add_argument('id', type=str)
    return ap.parse_args()

def get_sample_data(problem_id):
    url = URL + problem_id
    r = requests.get(url)
    soup = bs4(r.text, 'html.parser')
    data = soup.find_all('pre', attrs='sampledata')
    inputs = []
    outputs = []

    for sample in data:
        is_input = re.match('sample-input', sample.get('id'))
        if is_input: inputs.append(sample.text)
        else:        outputs.append(sample.text)

    return inputs, outputs

def write(inputs, outputs):
    if not os.path.exists('in'): os.mkdir('in')
    if not os.path.exists('out'): os.mkdir('out')

    for i in range(len(inputs)):
        f = open('in/%d.in' % i, 'w')
        f.write(inputs[i])
        f.close()
    for i in range(len(outputs)):
        f = open('out/%d.out' % i, 'w')
        f.write(outputs[i])
        f.close()

def main():
    args = get_arguments()
    [inputs, outputs] = get_sample_data(args.id)
    write(inputs, outputs)
    print('Successfully wrote %s test cases' % _g(len(inputs)))

main()
