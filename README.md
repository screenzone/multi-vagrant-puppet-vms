## Vagrant Multiple-VM Creation and Configuration
Automatically provision multiple VMs with Vagrant and VirtualBox. Automatically install, configure, and test
Puppet Master and Puppet Agents on those VMs. All instructions can be found in my blog post:
[http://wp.me/p1RD28-1kX](http://wp.me/p1RD28-1kX)


#### JSON Configuration File
The Vagrantfile retrieves multiple VM configurations from a separate `nodes.json` file. All VM configuration is
contained in the JSON file. You can add additional VMs to the JSON file, following the existing pattern. The
Vagrantfile will loop through all nodes (VMs) in the `nodes.json` file and create the VMs. You can easily swap
configuration files for alternate environments since the Vagrantfile is designed to be generic and portable.

#### Instructions
```
# on localhost
[+] vagrant up # brings up all VMs - slow!
vagrant ssh puppet.vm.local # coffee :-/

# test that puppet master was installed
[+] sudo service puppetmaster status
* master is running
[+] sudo puppet status info
Run mode 'user': local
[-] sudo service puppetmaster stop
[-] sudo puppet master --verbose --no-daemonize
# Ctrl+C to kill puppet master
sudo service puppetmaster start

# check for 'puppet' cert
[+] sudo puppet cert list --all
"node01.vm.local" (SHA256) 19:38:33:7D:FB:1B:B3:49:91:DE:A1:05:77:67:D3:D4:12:88:E7:E2:3B:5C:1C:42:2D:03:8B:65:39:E8:9B:DB
"node02.vm.local" (SHA256) 26:4C:7C:CB:6D:B8:27:49:CF:18:3E:CA:38:81:0A:95:79:4A:9E:67:9C:60:E3:1B:8E:A8:B2:A6:83:8D:7E:1C
+ "puppet.vm.local" (SHA256) 27:F3:D0:20:43:15:CB:6E:DF:00:06:D0:FB:5C:3C:6B:3A:8C:DD:0F:B7:2A:16:B8:00:4E:0A:68:68:ED:24:B8 (alt names: "DNS:puppet", "DNS:puppet.vm.local")

# setting up an agent for a *client*

# ssh into agent node

vagrant ssh node01.vm.local

# test that agent was installed
sudo service puppet status
* agent is running

sudo puppet agent --test --waitforcert=60 # initiate certificate signing request (CSR)
```
Back on the Puppet Master server (puppet.vm.local)
```
sudo puppet cert list # should see 'node01.vm.local' cert waiting for signature
[+] sudo puppet cert sign --all # sign the agent node(s) cert(s)
[+] sudo puppet cert list --all # check for signed cert(s)
```
#### Forwarding Ports
Used by Vagrant and VirtualBox. To create additional forwarding ports, add them to the 'ports' array. For example:
 ```
 "ports": [
        {
          ":host": 1234,
          ":guest": 2234,
          ":id": "port-1"
        },
        {
          ":host": 5678,
          ":guest": 6789,
          ":id": "port-2"
        }
      ]
```
#### Useful Multi-VM Commands
The use of the specific <machine> name is optional.
* `vagrant up <machine>`
* `vagrant reload <machine>`
* `vagrant destroy -f <machine> && vagrant up <machine>`
* `vagrant status <machine>`
* `vagrant ssh <machine>`
* `vagrant global-status`
* `facter` # on puppetmaster
* `sudo tail -50 /var/log/syslog`
* `sudo tail -50 /var/log/puppet/masterhttp.log`
* `tail -50 ~/VirtualBox\ VMs/postblog/<machine>/Logs/VBox.log'
