#!/usr/bin/env python

# conkytransmission.py by Eric Lien
# Designed to scrape torrent data from transmission-remote (on localhost) and output the data in a format
# that looks good with conkycolors themes.
# License is creative commons...give me some credit
#
# To make this work:
# 1) install conky, and preferably conkycolors because it
#    was made to fit those themes well
# 2) install transmission-cli and uninstall transmission-daemon
#    if installed
# 3) add a line like:
#    ${execpi 3 /path/to/conkytransmission.py}
#    to your ~/.conkyrc file

# I made a change to my conkycolors-generated .conkyrc
# so the execbar stretches across the width of conky:
# default_bar_size 0 3
# You will probably want to make a similar change

#tested on ubuntu 10.04 x86_64 with python v2.6.5 and conky v1.8.0 (conky-all package)

__author__="Eric Lien"
__date__ ="$Aug 17, 2010 9:45:50 PM$"
__version__="0.1 beta"

from subprocess import Popen, PIPE

class ConkyTransmission:
    """Gets transmission information and forms conky scripts from it"""
    torrents_output = ''
    global_stats = ''
    
    def __init__(self):
        self.run()
    
    # scrape data from transmission-remote, separating lines
    # returns list of lines of transmission-remote -l
    def scrapeTransmission(self):
        p = Popen(["transmission-remote", "-l"], stdout=PIPE, stderr=PIPE)
        output = p.communicate()[0]
        return output.splitlines()

    # Gathers output for conky into variables
    def getTorrentData(self):
        torrent_lines = self.scrapeTransmission()
        length = len(torrent_lines)
        count = 1
        for t in torrent_lines:
            #for lines that contain data about torrents
            if count > 1 and count < length:
                #store conky script for later use
                self.torrents_output+=Torrent(t).getOutput()
            #last line has relevent global stats
            elif count == length:
                #store global stats
                self.getGlobalStats(t)
            count = count + 1
            
    # Parses out global stats from last line of
    # transmission-remote -l output and forms 
    # conky script for it
    def getGlobalStats(self, info_line):
        out = ''
        #properties are separated by at least 2 spaces
        info_list = info_line.split("  ")
        count = 0
        for p in info_list:
            #strip extra white space
            p = p.lstrip().rstrip() 
            if p != '':
                count = count + 1
                # we only care about properties 3 and 4 (up and down speed)
                if count == 3:
                    total_up = getSpeed(p)                        
                elif count == 4:
                    total_down = getSpeed(p)
        self.global_stats='Global:${alignr}${color4}D: ${color0}'+total_down+'${color4} U: ${color0}'+total_up+'${color0}\n'
    
    # Runs the process from start to finish, printing data for conky
    def run(self):
        self.getTorrentData();
        if len(self.torrents_output) > 0:
            print self.torrents_output+self.global_stats
            
class Torrent:
    """Parses out torrent properties from a line of output of transmission-remote -l and builds a conky representation"""
    id = 0
    percent = 0
    downloaded = ""
    eta = ""
    up = 0.0
    down = 0.0
    ratio = 0.00
    status = ""
    file = ""

    # parses an input line of torrent properties into
    # class variables
    def __init__(self, properties):
        properties = properties.split("  ")
        count = 0
        for p in properties:
            p = p.lstrip().rstrip()
            if p != '':
                #convert non-blanks into proper format
                count = count + 1
                if count == 1:
                    self.setId(p)
                elif count == 2:
                    self.setPercent(p)
                elif count == 3:
                    self.downloaded = p
                elif count == 4:
                    self.setETA(p)
                elif count == 5:
                    self.up = getSpeed(p)
                elif count == 6:
                    self.down = getSpeed(p)
                elif count == 7:
                    self.ratio = p
                elif count == 8:
                    self.status = p
                elif count == 9:
                    self.file = p
    
    # sets id of torrent
    def setId(self, str):
        self.id = int(str.strip("*"))

    # sets percent downloaded
    def setPercent(self, str):
        self.percent = int(str.strip("%"))

    # sets estimated time left
    def setETA(self, str):
        if str == 'Unknown':
            self.eta = "?"
        else:
            self.eta = str
    
    # returns conky script from torrent data that was parsed  
    def getOutput(self):
        out = ''
        out+='${color5}'+self.file[:35]+'${color}${alignr}${color}'+`self.percent`+"%${color}\n"
        if self.status == 'Up & Down':
            out+="${color4}D: ${color0}"+self.down+"${color4}   ETA: ${color0}"+self.eta+"${color4}   U: ${color0}"+self.up+"${color4} R: ${color0}"+self.ratio+"${color0}\n"
        elif self.status == 'Seeding':
            out+="${color4}U: ${color0}"+self.up+"${color4}     ETA: ${color0}"+self.eta+"${color4}     R: ${color0}"+self.ratio+"${color}\n"
        elif self.status == 'Downloading':
            out+="${color4}D: ${color0}"+self.down+"${color4}   ETA: ${color0}"+self.eta+"${color4}   R: ${color0}"+self.ratio+"${color}\n"
        else:
            out+="${color4}S: ${color0}"+self.status+"${color4}   R: ${color0}"+self.ratio+"${color4}\n"
        return out+'${color4}${execbar echo "'+`self.percent`+'"}\n'
            
# function formatting KiB/s output by transmission into
# a human readable but succinct format
def getSpeed(str):
    kbps = float(str)
    if kbps > 1024:
        speed = `round(float(kbps/1024), 2)`
        unit = "M"
    else:
        speed = `round(kbps, 2)`
        unit = "K"
    return speed[:(speed.find('.') + 2)] + " " + unit

if __name__ == "__main__":
    ConkyTransmission()

