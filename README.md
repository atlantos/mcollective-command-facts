# mcollective-command-facts
##Overview
The facter plugin enables mcollective to use external command as a source for facts about your system.
External command should produce output in yaml format.

##Configuration
The following options can be set in server.cfg
* plugin.command - command used to get facts. Default is not defined.
* plugin.command.timeout - command execution timeout. Default is 10 seconds.

Sample configuration:

```
plugin.command = "/usr/bin/facter --puppet --yaml"
plugin.command.timeout = 10
```

