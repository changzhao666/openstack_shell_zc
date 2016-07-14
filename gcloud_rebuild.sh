#!/bin/bash
function instance_rebuild_all()
{
source ~/keystonerc_admin
for id in `nova list |grep ' [a-zA-Z0-9]\{8\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{12\} ' -o`
do
    echo "rebuid $id"
    image=`nova show $id| grep image|grep '[a-zA-Z0-9]\{8\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{12\}' -o`
    echo "image_id is $image"
    echo "nova rebuild $id $image"
    for i in { 1 .. 6 }
    do
        echo -n '.'
        sleep 1
    done
    echo -e "\033[32mdone \033[0m"
done
}
function instance_rebuild_ip()
{
source ~/keystonerc_admin
for ip in $@
do
    if [ $ip != $1 ] && [ $ip != $2 ]
    then
        id=` nova list |grep "$2$ip"| grep -o " [a-zA-Z0-9]\{8\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{12\}"`
        echo "rebuid $id"
        image=`nova show $id| grep image|grep '[a-zA-Z0-9]\{8\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{12\}' -o`
        echo "image_id is $image"
        echo "nova rebuild $id $image"
        nova rebuild $id $image
        for i in { 1 .. 6 }
        do
            echo -n '.'
            sleep 1
        done
        echo -e "\033[32mdone \033[0m"
    fi
done
}
function instance_list()
{
source ~/keystonerc_admin
nova list
}
if [  $# = 1 ] && [ $1 = "-a" ]
then
    echo 'ready to rebuild all.'
    instance_rebuild_all
elif [  $# = 1 ] && [ $1 = "-l" ]
then
    echo 'instances list:'
    instance_list
elif [ $# -gt 2 ] && [ $1 = '-i' ]
then
    echo 'ready to rebuild by ip.'
    instance_rebuild_ip $*
else
    echo -e "use \033[31m ~/gcloud_rebuild.sh -a\033[0m rebuild all."
    echo -e "use \033[31m ~/gcloud_rebuild.sh -i 10.1.15. 123 124\033[0m rebuild some instances by internal_ip or floating_ip."
fi
