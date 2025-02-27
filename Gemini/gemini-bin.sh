#!/bin/bash
printHelp()
{
	echo "
Gemini - System integrity application

Usage:
		
		gemini start - Starts up gemini services
		gemini stop - Shuts down gemini services
		
Arguments:

		-v   |   Verifies integrity of gemini system files

"
}
if [[ -z $1 ]]; then
	printHelp
fi