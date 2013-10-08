#!/bin/bash

expect <<- DONE
  set timeout -1
  spawn logKextClient

  # Look for  prompt
  expect "*?word:"
  send "logKext"
  send -- "\r"
  expect "*?ient >"
  send "print"
  send -- "\r"
  expect "*?ient >"
  send "quit"
  send -- "\r"
DONE