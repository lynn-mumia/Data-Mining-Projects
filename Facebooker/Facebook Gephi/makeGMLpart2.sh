
# makeGMLpart2.sh, cwj, 20-Oct-2016
# take the file I derived from my friends-friends examination
# and develop a script that can produce
# the gml file I need.
#
# make a list of files I expect to find
awk '
BEGIN { FS = "\t"  # make tab the input field sep
# apparently awk does not use the POSIX IFS, rather FS
       }
NF == 4 && length($3)>0 { userid = $3
  printf("%s.txt\n",userid) }
' friends-detail.txt > filelist.txt
#
# now we will loop through the files mentioned
# in the filelist.txt file, and process them to
# construct the entire gml file, or at least
# central part and the side parts that we have
# taken time to collect

#use this in the project
i=0
for f in `cat filelist.txt`
do
  echo 
  echo :$i:${f%%.txt}
  cat $f
  i=`expr $i + 1`
done > raw.txt
#
# now process that file which has everything we need
cat friends-detail.txt raw.txt | awk '
BEGIN { region = 0
   printf("graph\n[ directed 0\n") #header
   }
region == 0 { ans = split($0,a,"\t")
    lookup[a[4]] = a[1] # build associative array
	#printf("  remember %s as %s \n",a[4],a[1])
	# write out node report
	printf("  node [\n")
    printf("	 id  %d\n",a[1])
	printf("     label \"%s\"\n",a[4])
	printf("     degree %d\n",a[2])
	printf("       ]\n")
	}
$1 ~ /^:/ {
#&& $1 !~ /^:0:/ 
   # these lines are sentinels that we are
   # processing the mutual friends of a new friend
   region = 1
   fieldcount = split($0, fields, ":")
   lhs = fields[2]
   printf("Found the friends of friends of %d on line %d\n",lhs,NR)
   }
region == 1 && ($1 ~ /Friends$/ || $2 ~ /Friends$/) {
   on = NR }
region == 1 && NR == on + 1 {
   printf("   edge [\n")
   printf("      source %d\n",lhs)
   printf("      target %d\n",lookup[$0])
   printf("        ]\n") }
END { printf("]\n") } ' > friends.gml
