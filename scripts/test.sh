#!/bin/bash

spaces() {
  for ((i=0; i<$1; i++)); do
    echo -n " "
  done
}

green() {
  echo -e "\e[32m$@\e[0m"
}

red() {
  echo -e "\e[31m$@\e[0m"
}

highlight_url() {
  echo -n $@ | sed 's#\(http[^ ]*\)#\\e[35m\1\\e[0m#g'
}

test() {
  local command="$@"
  local command_length=$(echo $command | wc -c)
  local title=$(highlight_url $command)

  echo -en "curl $title$(spaces $((80 - $command_length)))"

  if curl -s -o /dev/null $command; then
    green "OK"
    return 0
  else
    red "FAIL"
    return 1
  fi
}

test http://open.backend.test
test --cacert /test-ca.pem https://secure.backend.test
test --cacert /test-ca.pem --cert /client.pem:password https://client.backend.test

test http://open-open.proxy.test
test http://open-secure.proxy.test
test http://open-client.proxy.test

test --cacert /test-ca.pem https://secure-open.proxy.test
test --cacert /test-ca.pem https://secure-secure.proxy.test
test --cacert /test-ca.pem https://secure-client.proxy.test

