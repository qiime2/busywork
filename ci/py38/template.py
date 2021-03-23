#!/usr/bin/env python

import sys
import os
import glob
import jinja2
import networkx as nx
import yaml


def fill_in_defaults(variables):
    variables = variables.copy()
    lookup = {}
    for idx, project in enumerate(variables['projects']):
        updated = { **variables['defaults'], **project }
        variables['projects'][idx] = updated
        lookup[updated['name']] = updated

    for project in variables['projects']:
        project['rev_deps'] = [rd for rd in variables['projects']
                               if project['name'] in rd['deps']]

    for project in variables['projects']:
        project['deps'][:] = [lookup[p] for p in project['deps']]

    return variables


def topological_sort(variables):
    G = nx.DiGraph()

    for project in variables['projects']:
        G.add_node(project['name'])

    for project in variables['projects']:
        for dep in project.get('deps', []):
            G.add_edge(project['name'], dep)

    return list(reversed(list(nx.topological_sort(G))))


def main(output_dir):
    root = os.path.dirname(__file__)
    with open(os.path.join(root, 'variables.yaml')) as fh:
        raw_vars = yaml.load(fh)
    # First, sort the projects, before filling in the defaults, that way we
    # don't have to deal with any circular references
    sorted_projects = topological_sort(raw_vars)
    variables = fill_in_defaults(raw_vars)
    # After filling in the default values, tack the sorted projects into the
    # context variable.
    variables['sorted_projects'] = sorted_projects

    env = jinja2.Environment(
        loader=jinja2.FileSystemLoader(os.path.join(root, 'jinja2')))

    for pipeline in env.list_templates(
            filter_func=lambda x: x.startswith('pipelines/') and
                                  (not os.path.basename(x).startswith('.'))):
        template = env.get_template(pipeline)
        pipeline_name = '-'.join([variables['defaults']['release_branch'],
                                  os.path.basename(pipeline)])
        with open(os.path.join(output_dir, pipeline_name), 'w') as fh:
            fh.write(template.render(variables))


if __name__ == '__main__':
    main(sys.argv[1])
