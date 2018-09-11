# MakeFBgml.sh, cwj, 10/17/2016 for CS457
# expects a file called friends-page-entire.html that you get by Ctrl-U on your friends page of Facebook after logging-in
# the entire list of your friends is on one line only, grep to find one of them
# no, facebook too tricky for that, you must scrape an ASCII version, since they hide such things
# make a file called friends-page.txt by ctrl-c, then ctrl-v into a text editor
# once you get to your friends page
awk '
BEGIN { on = 0
nf = 0 }
$1 ~ /Friends$/ || $2 ~ /Friends$/ { nf++
                  on = NR }
# after each friend you have their names and that friends number of friends, useful data
nf>0 && NR==on+1 { friendname[nf] = $0 }
# beware of friends with more than 1000 friends, delete commas from their numbers
nf>0 && NR==on+2 { sub(",", "", $1); degree[nf] = $1 }
END{ for(i=1;i<=nf;i++) {
   printf("%d\t%d\t\t%s\n",i, degree[i], friendname[i]) } } ' friends-page.txt > friends-extract.txt
#
# now comes the hard part, translating to the unique names for each of your friends.
# go back to facebook, and click on the friends one at a time
# you will find their facebook name on the URL
# you should then link to see what friends you have in common, and
# scrape that info into an ACSII file named with their unique facebook id
# you should also create a file called friends-details.txt in your editor of choice that starts
# with the friends-extract.txt file, but is being edited to add the ids for each as the new third field
#
