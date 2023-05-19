#!/bin/bash
exec supervisord -n
exec apache2 -D FOREGROUND