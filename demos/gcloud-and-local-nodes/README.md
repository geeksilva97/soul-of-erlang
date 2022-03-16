# Connect a local node and a node on Google Cloud

## Configure google cloud

To make connection works make sure that you have the port 4369 open. This port is used by the Erlang Port Mapping Daemon (epmd). Also you'll need to have a range of ports and enforces you node to execute in that range.

When getting your node up you can use the command `erl -name cloud@34.122.179.66 -setcookie codeminer -kernel inet_dist_listen_min 42000 inet_dist_listen_max 43000`.

It will enforeces your node to run between 42000 and 43000.


## Links
- https://stackoverflow.com/questions/18271589/in-erlang-can-two-nodes-in-different-network-communicate-with-each-other
- https://stackoverflow.com/questions/65694432/issue-with-connecting-erlang-elixir-vm-nodes-on-google-cloud-platform-gcp-sam

## Installing Erlang on VM
To install Erlang you can follow the instructions on https://github.com/erlang/otp.

Make sure that:
- You've installed the build-essentials package (`sudo apt-get install build-essentials`);
- You've installed the `ncurses-dev` package
