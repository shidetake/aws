#!/bin/sh

usage()
{
  echo "Usage: $0 [options]" 1>&2
  echo "  -l: list" 1>&2
  echo "  -r: run" 1>&2
  echo "  -s: stop" 1>&2
}

list()
{
  instances=$(aws rds describe-db-instances --query 'DBInstances[].[DBInstanceIdentifier, DBInstanceStatus]' --output text | tr '\t' '\n')
  echo $instances
}

run()
{
  list | awk '{print $1}' | while read instance
  do
    aws rds start-db-instance --db-instance-identifier $instance
  done
}

stop()
{
  list | awk '{print $1}' | while read instance
  do
    aws rds stop-db-instance --db-instance-identifier $instance
  done
}

if [ $# = 0 ]; then
  usage
  exit 1
fi

while getopts 'hlrs' OPT ; do
case $OPT in
  l)
    list
    exit 1
    ;;
  r)
    run
    exit 1
    ;;
  s)
    stop
    exit 1
    ;;
  h)
    usage
    exit 1
    ;;
esac
done
