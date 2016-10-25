#!/usr/bin/python

import sys, getopt


def read_file(filename, out):
    res = {}
    i = 0
    go_f = {}
    go_c = {}
    go_p = {}
    sb = ""

    for line in open(filename):

        parts = line.rstrip().split("\t")
        go = int(parts[1][3:])
        buf = str(go) + "\t" + parts[2]
        if parts[2] == "p":
            go_p[go] = "p"

        if parts[2] == "f":
            go_f[go] = "f"

        if parts[2] == "c":
            go_c[go] = "c"

    for go in sorted(go_f):
        print str(go) + "\t" + "f"
        sb += str(go) + "\t" + "f" + "\n"

    for go in sorted(go_p):
        print str(go) + "\t" + "p"
        sb += str(go) + "\t" + "p" + "\n"

    for go in sorted(go_c):
        print str(go) + "\t" + "c"
        sb += str(go) + "\t" + "c" + "\n"

    if len(out) != 0:
        f = open(out, 'w')
        f.write(sb)
        f.close()


def main(argv):
    inputfile = ''
    outputfile = ''
    try:
        opts, args = getopt.getopt(argv, "hi:o:", ["ifile=", "ofile="])
    except getopt.GetoptError:
        print 'xxx.py -i <inputfile> -o <outputfile>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'xxx.py -i <inputfile> -o <outputfile>'
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg
    print 'Input file is "', inputfile
    print 'Output file is "', outputfile
    read_file(inputfile, outputfile)


if __name__ == "__main__":
    main(sys.argv[1:])

