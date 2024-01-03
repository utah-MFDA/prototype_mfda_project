
import os
import argparse

def replace_file_var(template_dir, new_design, platform):
    # assign directory
    #directory = 'files'
    
    # iterate over files in
    # that directory

    for filename in os.listdir(template_dir):
        f = os.path.join(template_dir, filename)
        # checking if it is a file
        if os.path.isfile(f):
            replace_template(f, new_design, platform)
        if os.path.isdir(f):
            replace_file_var(f, new_design, platform)

def replace_template(in_file, new_design, platform):
    templateStr = '%template%'

    templateFStr= 'template'

    target_file = in_file.replace(templateFStr, new_design)

    o_in_file = open(in_file, 'r')

    os.makedirs(os.path.dirname(target_file), exist_ok=True)
    o_target_f= open(target_file, 'w')

    for line in o_in_file:
        o_target_f.write(line.replace(templateStr, new_design))
        

if __name__ == "__main__":

    parser = argparse.ArgumentParser()

    parser.add_argument('--template_dir', metavar='<template_dir>', type=str)

    parser.add_argument('--new_design', metavar='<new_design>', type=str)

    parser.add_argument('--platform', metavar='<platform>', type=str)

    args = parser.parse_args()

    print(args)

    replace_file_var(args.template_dir,
                    args.new_design,
                    args.platform)