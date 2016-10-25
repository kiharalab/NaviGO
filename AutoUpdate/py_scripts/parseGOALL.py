#!/usr/bin/python

import sys
import getopt


def read_category(filename):
    res = {}

    for line in open(filename):

        parts = line.rstrip().split("\t")
        go = int(parts[1][3:])
        res[go] = parts[2]

    return res


def read_file(filename, res, cate, out):
    sb = ""
    for line in open(filename):
        parts = line.rstrip().split("\t")
        go = int(parts[0][3:])
        if go in res:
            # modify this for different categories
            if res[go] == cate:
                print line.rstrip()
                sb += line

    if len(out) != 0:
        f = open(out, 'w')
        f.write(sb)
        f.close()


def main(argv):
    inputfile = ''
    outputfile = ''
    catefile = ''
    cate = ''
    try:
        opts, args = getopt.getopt(argv, "hi:o:c:k:", ["ifile=", "ofile=", "cfile=", "cate="])
    except getopt.GetoptError:
        print 'xxx.py -i <inputfile> -o <outputfile> -c <catefile> -k <category>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'xxx.py -i <inputfile> -o <outputfile> -c <catefile> -k <category>'
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg
        elif opt in ("-c", "--cfile"):
            catefile = arg
        elif opt in ("-k", "--cate"):
            cate = arg
    print 'Input file is "', inputfile
    print 'Output file is "', outputfile
    dic = read_category(catefile)
    read_file(inputfile, dic, cate, outputfile)


if __name__ == "__main__":
    main(sys.argv[1:])

