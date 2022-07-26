
if [ $# -lt 3 ]; then
    # TODO: print usage
    echo -e "You need to specify a namespace(ns), service, port please \n"
    exit 1
fi
ADDRESS=$(hostname -I | cut -d' ' -f1)
# echo $ADDRESS

kubectl port-forward -n $1 svc/$2 $3 --address=$ADDRESS