find $1 -name *.$2 -exec grep -H "$3" '{}' \; -print 2>/dev/null;
