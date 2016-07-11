#!/bin/bash
#
# DTadrzak

set -e

git clone http://github.com/$REPO_NAME/stackanetes.git
cd stackanetes
git checkout $BRANCH_NAME

pip install -Ur requirements.txt

python setup.py install
./generate_config_file_sample.sh

sed -i "s@#docker_image_tag = mitaka@docker_image_tag = $DOCKER_IMAGE_TAG@g" /etc/stackanetes/stackanetes.conf
sed -i "s@#minion_interface_name = eno1@minion_interface_name = $INTERFACE_NAME@g" /etc/stackanetes/stackanetes.conf
sed -i "s@#docker_registry = quay.io/stackanetes@docker_registry = $DOCKER_REGISTRY@g" /etc/stackanetes/stackanetes.conf
sed -i "s@#ceph_mons = 192.168.10.1,10.91.10.2@ceph_mons = $CEPH_MONS@g" /etc/stackanetes/stackanetes.conf
sed -i "s@#ceph_admin_keyring = ASDA==@ceph_admin_keyring = $CEPH_ADMIN_KEYRING@g" /etc/stackanetes/stackanetes.conf
sed -i "s@#ceph_enabled = true@ceph_enabled = $CEPH_ENABLED@g" /etc/stackanetes/stackanetes.conf


./manage_all.py run

# temporary workaround for openvswitch-agent
sleep 240
stackanetes kill neutron-openvswitch-agent
sleep 10
stackanetes run neutron-openvswitch-agent
sleep 60

openstack network create nettest
openstack subnet create test --subnet-range 192.168.2.0/24 --network nettest
openstack image create coreos --disk-format iso --file /root/coreos.iso  --public  
openstack server create test --image coreos --flavor m1.small

while true; do
  if [[ $(openstack server list --status=ACTIVE) ]]; then
    ./manage_all.py kill
    echo "TEST PASSED"
    exit 0
  fi
  if [[ $(openstack server list --status=ERROR) ]]; then
    echo "TEST FAILED"
    exit 0 
  fi
  sleep 1
done


