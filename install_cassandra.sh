DATA_DIR='/home/ubuntu'
master_ip="vm0"
#master_ip=""
#
#for ip in `cat /home/$USER/ips.txt`
#do
#        master_ip=$ip
#        break
#done

remote_command='
sudo apt upgrade --yes
sudo apt install apt-transport-https --yes
gpg --keyserver keyserver.ubuntu.com --recv-keys 7E3E87CB
gpg --export --armor 7E3E87CB | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/cassandra-key.gpg
echo "deb https://debian.cassandra.apache.org 40x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.list
'

remote_command1='
sudo apt upgrade --yes
sudo apt install apt-transport-https --yes
echo deb https://debian.cassandra.apache.org 40x main | sudo tee /etc/apt/sources.list.d/Cassandra.sources.list
wget -q -O- https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
'

#https://downloads.apache.org/cassandra/KEYS

for ip in `cat /home/$USER/ips.txt`
do
        ssh -o "StrictHostKeyChecking no" $ip "$remote_command1"
done

remote_command='
sudo apt update --yes
sudo apt install cassandra -y
'

for ip in `cat /home/$USER/ips.txt`
do
        ssh -o "StrictHostKeyChecking no" $ip "$remote_command"
done

remote_command='
sudo systemctl stop cassandra
sudo rm -rf /var/lib/cassandra/*
sleep 3
'

for ip in `cat /home/$USER/ips.txt`
do
        ssh -o "StrictHostKeyChecking no" $ip "$remote_command"
done
