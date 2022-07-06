
if [ $# -lt 3 ]; then
    # TODO: print usage
    echo -e "You need to specify a namespace(ns), pod, service please \n"
    exit 1
fi


kubectl port-forward -n $1 $2  $3 --address=10.0.0.5