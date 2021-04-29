# ----------------------------------------------------------------------------
# Copyright (c) 2017-2021, QIIME 2 development team.
#
# Distributed under the terms of the Modified BSD License.
#
# The full license is in the file LICENSE, distributed with this software.
# ----------------------------------------------------------------------------

#!/usr/bin/env python

import sys
import os
import glob
import jinja2
import yaml

def main(output_dir):
    root = os.path.dirname(__file__)
    with open(os.path.join(root, 'variables.yaml')) as fh:
        variables = yaml.load(fh)

    env = jinja2.Environment(
        loader=jinja2.FileSystemLoader(os.path.join(root, 'jinja2')))

    for pipeline in env.list_templates(
            filter_func=lambda x: x.startswith('pipelines/') and
                                  (not os.path.basename(x).startswith('.'))):
        template = env.get_template(pipeline)
        pipeline_name = os.path.basename(pipeline)
        with open(os.path.join(output_dir, pipeline_name), 'w') as fh:
            fh.write(template.render(variables))

if __name__ == '__main__':
    main(sys.argv[1])
