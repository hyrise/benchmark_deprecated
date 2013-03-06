#!/usr/bin/env python

import time

# Import all queries
from benchmark.queries import *
from benchmark.benchuser import User as User
from benchmark.layoutuser import LayoutUser as LayoutUser
import benchmark.tools as tools

#-----------------------------------------------------------------------------
# SCRIPT 
#-----------------------------------------------------------------------------
def script():
    ''' example of how to use the User class to do benchmarking 
    '''

    server = "http://192.168.31.39"
    port = 5001
    time_factor = 600
    prefix = tools.getlastprefix("queued_1k_idx")
    queries = ("q6a", "q6b", "q7", "q8", "q7idx", "q8idx", "q10", "q11", "q12")


    users = []
    for i in range(1):
         users.append(User(i, server, port, 100, 0, "NO_PAPI", queries, prefix=prefix, db="cbtr3"))


    lu = LayoutUser(99, "VBAP", "layouts/VBAP_ROW.tbl", prefix=prefix, port=port)
    lu.start()
    lu.join()

    lu = LayoutUser(99, "VBAK", "layouts/VBAK_ROW.tbl", prefix=prefix, port=port)
    lu.start()
    lu.join()

    print 'starting users...'
    for user in users:
        user.start()
    print 'users started'

    time.sleep(min(15, time_factor))
    for user in users:
        user.startLogging()

    print 'waiting...'
    time.sleep(time_factor)

    print "now"
    #####################################################
    lu = LayoutUser(99, "VBAP", "layouts/VBAP_COL.tbl", 1, prefix=prefix, port=port)
    lu.start()
    lu.join()

    lu = LayoutUser(99, "VBAK", "layouts/VBAK_COL.tbl", 1, prefix=prefix, port=port)
    lu.start()
    lu.join()
    #####################################################

    time.sleep(time_factor)
    print 'waiting finished'

    print 'stopping users...'
    for user in users:
        user.stop()

    print 'waiting for users to finish...'
    for user in users:
        user.join()

    print 'script finished'
    for user in users:
        user.stats()

if __name__ == '__main__':
    script()
