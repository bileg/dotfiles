
# list users running processes

ps aux | awk '{ print $1 }' | sed '1 d' | sort | uniq


