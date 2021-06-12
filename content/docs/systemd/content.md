+++
fragment = "content"
weight = 100

title = "systemd"

[sidebar]
  sticky = true
+++

Running Euterpe manually is all good but at some point you would want it to start by itself on reboot. Especially when it is installed on a headless machine such as a server.

If your operating system is using [systemd](https://systemd.io/) then Euterpe provides a unit file template to help you with that.

### Unit File Template

```
[Unit]
[Unit]
Description=Euterpe Streaming Media Server
ConditionFileIsExecutable=/usr/bin/euterpe
Documentation=https://listen-to-euterpe.eu/docs/
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/euterpe
Restart=on-failure
User=$USER
Group=$GROUP
WorkingDirectory=/home/$USER/.euterpe
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
Alias=httpms
```

Make sure to replace `$USER` and `$GROUP` from the template with the OS user and group which would be used for running the Euterpe binary. Make sure they have permissions to read your library directories. Only read permission is required.

For the latest version of this template see the [Euterpe source repository](https://github.com/ironsmile/euterpe/blob/master/tools/euterpe.service).

### Setting Up

Find out from where `systemd` loads its units. [Its man page](https://www.freedesktop.org/software/systemd/man/systemd.unit.html) will be of great help. For example, a good place for the unit on Ubuntu servers will be `/lib/systemd/system/euterpe.service`.

### Start

Once the unit file is in place run the following to start Euterpe:

```
systemctl start euterpe
```

### Stop

To stop it

```
systemctl stop euterpe
```

### Run on Start-Up

In order to run Euterpe on every OS start-up run the following:

```
systemctl enable euterpe
```
