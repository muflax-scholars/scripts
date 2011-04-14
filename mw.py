#!/usr/bin/env python3
# Copyright muflax <mail@muflax.com>, 2010
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

import optparse, os, subprocess, sys, platform

def main():
    p = optparse.OptionParser()
    p.add_option("-+", "--vol", action="store", dest="volume", type="int", 
                 help="increase volume by VOLUME")
    p.add_option("-l", "--left", action="store_const", const="left", dest="where", 
                 help="left screen", default="left")
    p.add_option("-m", "--middle", action="store_const", const="middle", dest="where", 
                 help="left screen", default="left")
    p.add_option("-r", "--right", action="store_const", const="right", dest="where", 
                 help="right screen")

    opt, args = p.parse_args()

    host = platform.node()
    display = ":0.0"
    # host-specific options
    if host == "azathoth":
        if opt.where == "middle":
            args[:0] = ["-delay", "-0.05"]
    
        # screen handling
        if opt.where == "left":
            args[:0] = ["-xineramascreen", "0"]
            display = ":0.1"
        elif opt.where == "middle":
            args[:0] = ["-xineramascreen", "0"]
        elif opt.where == "right":
            args[:0] = ["-xineramascreen", "1"]
        else:
            optparse.error("wtf is '{}'?!".format(opt.where))

    # audio filter
    args[:0] = ["-af-add", "scaletempo"]
    if opt.volume:
        args[:0] = ["-af-add", "volume={}".format(opt.volume)]
    
    # azathoth needs a wrapper, though
    cmd = ["mplayer"]
    os.environ["DISPLAY"] =  display
    if host == "azathoth" and opt.where == "right":
        try:
            os.system("nvidia-settings -a XVideoSyncToDisplay=DFP-1 >/dev/null")
            ret = subprocess.call(cmd + args, env=os.environ)
        except Exception as e:
            print(e)
        finally:
            os.system("nvidia-settings -a XVideoSyncToDisplay=DFP-0 >/dev/null")
    else:
        ret = subprocess.call(cmd + args, env=os.environ)

    sys.exit(ret)

if __name__ == "__main__":
    main()
