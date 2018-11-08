# -*- coding: utf-8 -*-
"""
Created on Wed Nov  7 09:26:09 2018

@author: danielmaxwell
"""

def test_parms(a, b):
    return(a * b)
# end test_parms

# Pass a string and an integer    
test_parms('Howdy', 3)
test_parms(3, 'Howdy')

# Pass two integers
test_parms(2, 2)

# Pass two floats
test_parms(2.2, 4.8)

# Pass two strings
test_parms('Howdy','Howdy')

def test_parms(a, b):
    try:
        return(a * b)
        
    except TypeError:
        print('Datatype error in test_parms().')
        return(-99)
# end test_parms

# Pass two floats
test_parms(2.2, 4.8)

# Pass two strings
test_parms('Howdy','Howdy')



