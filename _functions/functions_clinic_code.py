# -*- coding: utf-8 -*-
"""
Created on Wed Nov  7 09:26:09 2018

@author: danielmaxwell
"""

def multiply(arg_1, arg_2):
    '''This function takes two arguments (arg_1, arg2), multiplies them, and returns the result.  
    '''
    return(arg_1 * arg_2)

# end multiply()
    
# Pass a string and an integer    
multiply('Contract ', 3)
multiply(3, 'Contract ')

# Pass two integers
assert isinstance(multiply(2, 2), int)

# Pass two floats
assert isinstance(multiply(2.2, 4.8), float)

# Pass an integer and a string
assert isinstance(multiply(2, 'Contract '), str)
assert isinstance(multiply('Contract ', 2), str)

multiply('Contract ', 2.4)

multiply('Contract ','Contract ')

# Pass two strings
multiply('Howdy','Howdy')

def mutiply(arg_1, arg_2):
    try:
        return(arg_1 * arg_2)
        
    except TypeError:
        print('Datatype error in test_parms().')
        return(-99)
# end test_parms

# Pass two floats
multiply(2.2, 4.8)

# Pass two strings
multiply('Howdy','Howdy')



