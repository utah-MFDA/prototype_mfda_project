


if __name__ == "__main__":

    import argparse

    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    
    ap.add_argument('--infile', metavar='<ifile>', dest='ifile', type=str,
                    help="input file.")
    ap.add_argument('--platform', metavar='<platform>', dest='platform', type=str,
                    help="design platform.")
    ap.add_argument('--design', metavar='<design>', dest='design', type=str,
                    help="chip design name.")
    
    args = ap.parse_args()
    
    inScad = open(args.ifile, 'r')
    oScad  = open(args.ifile.replace('.scad','_owBulk.scad'), 'w+')
    
    firstCube = True
    
    for line in inScad.readlines():
        if "use" in line:
            subStr = "/place_and_route/pnr/results/" + args.platform + "/" + args.design + "/base/"
            print(subStr)
            line = line.replace(subStr, '')
        if ('cube' in line) and firstCube:
            firstCube = False
            line = '//' + line
        oScad.write(line)
