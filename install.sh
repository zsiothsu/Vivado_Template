#!/bin/bash
 
if [[ -d /opt/Vivado_Template ]]; then
	rm -rf /opt/Vivado_Template
fi
cp -r scripts /opt/Vivado_Template
if [[ -f /usr/bin/vivado_project ]]; then
	rm /usr/bin/vivado_project
fi
ln -rs /opt/Vivado_Template/vivado_project /usr/bin/vivado_project

