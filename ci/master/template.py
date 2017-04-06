#!/usr/bin/env python

import sys
import os
import jinja2
import yaml

PIPELINES = ['staging.yaml', 'release.yaml']

def fill_in_defaults(variables):
    variables = variables.copy()
    lookup = {}
    for idx, project in enumerate(variables['projects']):
        updated = { **variables['defaults'], **project }
        variables['projects'][idx] = updated
        lookup[updated['name']] = updated

    for project in variables['projects']:
        # There is a cycle here causing repr/str to recurse forever, it really
        # doesn't matter unless you are trying to print
        project['deps'][:] = [lookup[p] for p in project['deps']]

    return variables

def main(output_dir):
    root = os.path.dirname(__file__)
    with open(os.path.join(root, 'variables.yaml')) as fh:
        variables = fill_in_defaults(yaml.load(fh))

    env = jinja2.Environment(
        loader=jinja2.FileSystemLoader(os.path.join(root, 'jinja2')))

    for pipeline in PIPELINES:
        template = env.get_template(pipeline)
        pipeline_name = \
            '-'.join([variables['defaults']['release_branch'], pipeline])
        with open(os.path.join(output_dir, pipeline_name), 'w') as fh:
            fh.write(template.render(variables))

if __name__ == '__main__':
    main(sys.argv[1])
