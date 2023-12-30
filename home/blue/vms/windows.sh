#!/bin/dash

virt-manager --connect qemu:///system --show-domain-console Windows


# Check if the network "default" is running
network_status=$(virsh -c qemu:///system net-info default | grep "Active:" | awk '{print $2}')

if [ "$network_status" != "active" ]; then
    virsh -c qemu:///system net-start default
    echo "Started network 'default'"
else
    echo "Network 'default' is already running"
fi

# Check if the VM "Windows" is running
vm_status=$(virsh -c qemu:///system list --all | grep "Windows" | awk '{print $3}')

if [ "$vm_status" != "running" ]; then
    virsh -c qemu:///system start Windows
    echo "Started VM 'Windows'"
else
    echo "VM 'Windows' is already running"
fi

exit
