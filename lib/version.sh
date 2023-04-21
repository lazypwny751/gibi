#!/bin/bash

version:convert() {
	local _conv_=() ver="0" multiplier="1"
	if [[ -n "${1}" ]] ; then
		read -a _conv_ <<< "${1//"."/" "}"
		for null in $(seq 2 ${#_conv_[@]}) ; do
			local multiplier="$((multiplier * 10))"
		done

		for i in "${_conv_[@]}" ; do
			local num="$((multiplier * i))"
			local multiplier="$((multiplier / 10))"
			local ver="$((ver + num))"
		done
		if [[ -n "${ver}" ]] ; then
			echo "${ver}"
		else
			return 2
		fi
	else
		return 1
	fi
}

gibi:compare() {
	if [[ -n "${1}" ]] && [[ -n "${2}" ]] ; then
		if [[ "${1}" -gt "${2}" ]] ; then
			echo "greater"
		elif [[ "${1}" -eq "${2}" ]] ; then
			echo "equal"
		elif [[ "${1}" -lt "${2}" ]] ; then
			echo "little"
		else
			return 1
		fi
	else
		echo "insufficient parameter!"
		return 1
	fi
}