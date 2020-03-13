#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2020-03-12 20:21:42 +0000 (Thu, 12 Mar 2020)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

# Lists all PostgreSQL databases using adjacent impala_shell.sh script
#
# FILTER environment variable will restrict to matching databases (if giving <db>.<table>, matches up to the first dot)
#
# AUTOFILTER if set to any value skips information_schema, performance_schema, sys and mysql databases
#
# Tested on MySQL 8.0.15

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(dirname "$0")"

"$srcdir/mysql.sh" -s -e 'SELECT DISTINCT(table_schema) FROM information_schema.tables ORDER BY table_schema;' "$@" |
sed 's/^[[:space:]]*//; s/[[:space:]]*$//; /^[[:space:]]*$/d' |
if [ -n "${AUTOFILTER:-}" ]; then
    grep -Ev '^(information_schema|performance_schema|sys|mysql)$'
else
    cat
fi |
while read -r db; do
    if [ -n "${FILTER:-}" ] &&
       ! [[ "$db" =~ ${FILTER%%.*} ]]; then
        continue
    fi
    printf "%s\n" "$db"
done
