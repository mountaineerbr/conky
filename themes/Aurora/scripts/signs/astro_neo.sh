#!/bin/bash
# Astro.sh
# by Crinos512 (17 Feb, 2011)
# updated by Sector11 (21 Feb, 2011)
# Usage:
#  ${execp ~/path/to/Astro.sh}
#
# Aquarius      Jan 20 - Feb 18
# Pisces        Feb 19 - Mar 20
# Aries         Mar 21 - Apr 19
# Taurus        Apr 20 - May 20
# Gemini        May 21 - Jun 20
# Cancer        Jun 21 - Jul 22
# Leo           Jul 23 - Aug 22
# Virgo         Aug 23 - Sep 22
# Libra         Sep 23 - Oct 22
# Scorpio       Oct 23 - Nov 21
# Sagittarius   Nov 22 - Dec 21
# Capricorn     Dec 22 - Jan 19

Month=`date +%m`
Day=`date +%d`

case "$Month"  in
  01 ) if [ "$Day" -le "20" ] ; then Sign="capricorn" ; else Sign="aquarius" ; fi ;;
  02 ) if [ "$Day" -le "19" ] ; then Sign="aquarius" ; else Sign="pisces" ; fi ;;
  03 ) if [ "$Day" -le "21" ] ; then Sign="pisces" ; else Sign="aries" ; fi ;;
  04 ) if [ "$Day" -le "20" ] ; then Sign="aries" ; else Sign="taurus" ; fi ;;
  05 ) if [ "$Day" -le "21" ] ; then Sign="taurus" ; else Sign="gemini" ; fi ;;
  06 ) if [ "$Day" -le "21" ] ; then Sign="gemini" ; else Sign="cancer" ; fi ;;
  07 ) if [ "$Day" -le "23" ] ; then Sign="cancer" ; else Sign="leo" ; fi ;;
  08 ) if [ "$Day" -le "23" ] ; then Sign="leo" ; else Sign="virgo" ; fi ;;
  09 ) if [ "$Day" -le "23" ] ; then Sign="virgo" ; else Sign="libra" ; fi ;;
  10 ) if [ "$Day" -le "23" ] ; then Sign="libra" ; else Sign="scorpio" ; fi ;;
  11 ) if [ "$Day" -le "22" ] ; then Sign="scorpio" ; else Sign="sagittarius" ; fi ;;
  12 ) if [ "$Day" -le "22" ] ; then Sign="sagittarius" ; else Sign="capricorn" ; fi ;;
  *  ) Sign="ERROR" ;;
esac

case "$Sign"    in
    "capricorn" ) BeginDate="Dec 22" ; EndDate="Jan 19" ; ;;
    "aquarius" ) BeginDate="Jan 20" ; EndDate="Feb 18" ; ;;
    "pisces" ) BeginDate="Feb 19" ; EndDate="Mar 20" ; ;;
    "aries" ) BeginDate="Mar 21" ; EndDate="Apr 19" ; ;;
    "taurus" ) BeginDate="Apr 20" ; EndDate="May 20" ; ;;
    "gemini" ) BeginDate="May 21" ; EndDate="Jun 20" ; ;;
    "cancer" ) BeginDate="Jun 21" ; EndDate="Jul 22" ; ;;
    "leo" ) BeginDate="Jul 23" ; EndDate="Aug 22" ; ;;
    "virgo" ) BeginDate="Aug 23" ; EndDate="Sep 22" ; ;;
    "libra" ) BeginDate="Sep 23" ; EndDate="Oct 22" ; ;;
    "scorpio" ) BeginDate="Oct 23" ; EndDate="Nov 21" ; ;;
    "sagittarius" ) BeginDate="Nov 22" ; EndDate="Dec 21" ; ;;
    * ) BeginDate="XXX XX" ; EndDate="XXX XX" ; ;;
esac

echo "\${image ~/.conky/Aurora/images/signs/$Sign.png -p 0,80 -s 150x150}\${image ~/.conky/Aurora/images/stars/$Sign.png -p 180,80 -s 150x150}$BeginDate    |    $Sign    |    $EndDate"
echo "\${goto 50}Sign\${goto 230}Star"