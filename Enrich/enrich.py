import sys, re
from urllib.request import urlopen
from decimal import *
getcontext().prec = 10

# NaviGO is  released under the terms of the GNU Lesser General Public License Ver.2.1. 
# https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html
# -------
# Qing Wei


def parseArgs(args):
  """Parses arguments vector, looking for switches of the form -key {optional value}.
  For example:
    parseArgs([ 'main.py', '-p', 5 ]) = {'-p':5 }"""
  args_map = {}
  curkey = None
  for i in range(1, len(args)):
    if args[i][0] == '-':
      args_map[args[i]] = True
      curkey = args[i]
    else:
      assert curkey
      args_map[curkey] = args[i]
      curkey = None
  return args_map

def validateInput(args):
    args_map = parseArgs(args)
    #human organism id
    organism_id = 9606
    input_file = None
    
    if '-o' in args_map:
      organism_id = int(args_map['-o'])
    if '-f' in args_map:
      input_file = args_map['-f']
    return [organism_id, input_file]
    
def nCr(n, r):
    if r > n / 2.0:
        r = n - r
    ans = 1
    i = 1
    while i <= r:
        tmp = n - r + i
        ans = Decimal(ans) * Decimal(tmp)
        tmp = i
        ans = Decimal(ans) / Decimal(tmp)
        i += 1
    
    return ans
    
def f(k, N, m, n, _c):
    a = nCr(m, k)
    b = nCr(N-m, n-k)
    c = _c
    res = a * b
    #getcontext().prec = 10000
    res = Decimal(res) / Decimal(c)
    #print(res)
    return res
    pass

def calculate_enrich(org, go, k, n):
    tmp = urlopen("http://www.uniprot.org/uniprot/?query=taxonomy%3A%22"+str(org)+"%22+AND+(GO:0008150+OR+GO:0003674+OR+GO:0005575)+AND+reviewed:yes&sort=score&format=rss").read()
    #print str(tmp)
    #need to check match for future
    match = re.search('totalResults(.)*totalResults', str(tmp))
    total = int(re.sub(r'[^0-9]', '', match.group(0)))
    #print total
    
    tmp = urlopen("http://www.uniprot.org/uniprot/?query=taxonomy%3A%22"+str(org)+"%22+AND+"+go+"+AND+reviewed%3Ayes&sort=score&format=rss").read()
    #print str(tmp)
    #need to check match for future
    match = re.search('totalResults(.)*totalResults', str(tmp))
    m = int(re.sub(r'[^0-9]', '', match.group(0)))
    
    _sum = 0
    i = k
    _c = nCr(total, n)
    while i <= n:
        _sum += f(i, total, m, n, _c)
        i += 1
    
    return _sum

def main():
    usage = "python enrich.py [-o organism_id] -f input"
    arguments = validateInput(sys.argv)
    organism_id, input_file = arguments
    gohash = {}
    proteinhash = {}
    pro_num = 0

    #fout = open("GO-above-pval0.01.txt", "w");
    #print organism_id, input_file
    if input_file == None:
        print(usage)
    else:
        f = open(input_file)
        for line in f:
            if line[-1] == "\n": 
                tmp = line[:-1]
            else:
                tmp = line
            parts = tmp.split(' ')
            if parts != None and len(parts) == 2:
                goterms = parts[1].split(',')
                #print(goterms)
                for go in goterms:
                    if len(go) == 10:
                        if go in gohash:
                            gohash[go] += 1
                        else:
                            gohash[go] = 1
                        if go in proteinhash:
                            proteinhash[go].append(parts[0])
                        else:
                            proteinhash[go] = []
                            proteinhash[go].append(parts[0])
            else:
                continue
#                print "Error parsing the file!"
#                exit(0)
            pro_num += 1
            
    #print gohash
    #print proteinhash
    #print(gohash)
    print("GO term, P-value, Count")
    for go in gohash:
        pval = calculate_enrich(organism_id, go, gohash[go], pro_num);
        print(go + "," + str(pval)+","+str(gohash[go]));
        
	#if pval <= 0.01:
        #fout.write(go + ",");
       
    #fout.close();
if __name__ == '__main__':
    main()



