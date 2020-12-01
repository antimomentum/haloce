while true
do
 ipset add LEGIT $(awk 'END{match($0,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/); ip = substr($0,RSTART,RLENGTH); print ip}' output.txt)
 sleep 0.018
done
