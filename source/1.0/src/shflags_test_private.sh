#! /bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
#
# Author: kate.ward@forestent.com (Kate Ward)
#
# shFlags unit test for the internal functions

# load test helpers
. ./shflags_test_helpers

# set shwordsplit for zsh
[ -n "${ZSH_VERSION:-}" ] && setopt shwordsplit

#------------------------------------------------------------------------------
# suite tests
#

testGetFlagInfo()
{
  __flags_blah_foobar='1234'

  rslt=`_flags_getFlagInfo 'blah' 'foobar'`
  assertTrue 'request for valid flag info failed' $?
  assertEquals 'invalid flag info returned' "${__flags_blah_foobar}" "${rslt}"

  rslt=`_flags_getFlagInfo 'blah' 'hubbabubba' >${stdoutF} 2>${stderrF}`
  assertEquals 'invalid flag did not result in an error' ${FLAGS_ERROR} $?
  assertErrorMsg 'invalid flag'
}

testItemInList()
{
  list='this is a test'

  _flags_itemInList 'is' ${list}
  assertTrue 'unable to find leading string (this)' $?

  _flags_itemInList 'is' ${list}
  assertTrue 'unable to find string (is)' $?

  _flags_itemInList 'is' ${list}
  assertTrue 'unable to find trailing string (test)' $?

  _flags_itemInList 'abc' ${list}
  assertFalse 'found nonexistant string (abc)' $?

  _flags_itemInList '' ${list}
  assertFalse 'empty strings should not match' $?

  _flags_itemInList 'blah' ''
  assertFalse 'empty lists should not match' $?
}

testValidateBoolean() {
  # valid values
  for value in ${TH_BOOL_VALID}; do
    _flags_validateBoolean "${value}"
    assertTrue "valid value (${value}) did not validate" $?
  done

  # invalid values
  for value in ${TH_BOOL_INVALID}; do
    _flags_validateBoolean "${value}"
    assertFalse "invalid value (${value}) validated" $?
  done
}

testValidateFloat() {
  # valid values
  for value in ${TH_INT_VALID} ${TH_FLOAT_VALID}; do
    _flags_validateFloat "${value}"
    assertTrue "valid value (${value}) did not validate" $?
  done

  # invalid values
  for value in ${TH_FLOAT_INVALID}; do
    _flags_validateFloat "${value}"
    assertFalse "invalid value (${value}) validated" $?
  done
}

testValidateInteger() {
  # valid values
  for value in ${TH_INT_VALID}; do
    _flags_validateInteger "${value}"
    assertTrue "valid value (${value}) did not validate" $?
  done

  # invalid values
  for value in ${TH_INT_INVALID}; do
    _flags_validateInteger "${value}"
    assertFalse "invalid value (${value}) validated" $?
  done
}

#------------------------------------------------------------------------------
# suite functions
#

oneTimeSetUp()
{
  # load flags
  [ -n "${ZSH_VERSION:-}" ] && FLAGS_PARENT=$0
  . ${TH_SHFLAGS}

  tmpDir="${__shunit_tmpDir}/output"
  mkdir "${tmpDir}"
  stdoutF="${tmpDir}/stdout"
  stderrF="${tmpDir}/stderr"
}

setUp()
{
  flags_reset
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${TH_SHUNIT}