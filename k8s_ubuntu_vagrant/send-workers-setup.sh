echo -e "[TASK 1] Copy files to workers, Ip worker:$1 \n"

scp *.sh $1:$HOME
# scp  $1:$HOME

# sftp 10.0.0.6