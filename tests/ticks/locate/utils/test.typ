#import "/src/logic/tick-locate.typ": *


#assert.eq(_estimate-significant-digits((1,1.25)), 2)
#assert.eq(_estimate-significant-digits((1,)), 0)
#assert.eq(_estimate-significant-digits((1.001,1.002)), 3)
#assert.eq(_estimate-significant-digits((2.4, 1)), 1)
#assert.eq(_estimate-significant-digits((2.4, 1.23424), threshold: 5), 5)
#assert.eq(_estimate-significant-digits((2.4, 1.324)), 3)
#assert.eq(_estimate-significant-digits((0.000002, 0.000004)), 6)
#assert.eq(_estimate-significant-digits((0.00000002, 0.00000004)), 8)
#assert.eq(_estimate-significant-digits((2.4e10, 1.324e10)), 0)
#assert.eq(_estimate-significant-digits((2.4e10, -234)), 0)
#assert.eq(_estimate-significant-digits((-334.3, 23.2)), 1)
#assert.eq(_estimate-significant-digits((2.4e-10, 1.324e-10)), 13)



#assert.eq(_get-best-step(0.1), 1)
#assert.eq(_get-best-step(0.14), 1)
#assert.eq(_get-best-step(0.15), 2)
#assert.eq(_get-best-step(0.2), 2)
#assert.eq(_get-best-step(0.3), 2)
#assert.eq(_get-best-step(0.4), 5)
#assert.eq(_get-best-step(0.5), 5)
#assert.eq(_get-best-step(0.6), 5)
#assert.eq(_get-best-step(0.8), 10)
#assert.eq(_get-best-step(0.9), 10)


#assert.eq(_fit-up(-4.2, .2), -21)
#assert.eq(_fit-up(-4.3, .2), -21)
#assert.eq(_fit-up(-4.1, .2), -20)
#assert.eq(_fit-up(4.2, .2), 21)
#assert.eq(_fit-up(4.2, 2), 3)
#assert.eq(_fit-up(4200, 2000), 3)
#assert.eq(_fit-up(-4.2, 5), 0)

#assert.eq(_fit-down(7, 2), 3)
#assert.eq(_fit-down(7e30, 2e25, offset: 5e30), 350000)
#assert.eq(_fit-down(-4.2, .2), -21)
#assert.eq(_fit-down(4.2, .2), 21)
#assert.eq(_fit-down(4.2, 2), 2)
#assert.eq(_fit-down(-4.2, 2), -3)
#assert.eq(_fit-down(4200, 2000), 2)
#assert.eq(_fit-down(-4.2, 5), -1)




#assert.eq(_discretize-up(24, 5, 0), 25)
#assert.eq(_discretize-up(1.2, 2, -1), 1.2)
#assert.eq(_discretize-up(2345.23, 2, 1), 2360)
#assert.eq(_discretize-up(2345.23, 2, 0), 2346)
#assert.eq(_discretize-up(34, 5, 0), 35)
#assert.eq(_discretize-up(1015, 11, 0), 1023)
#assert.eq(_discretize-up(10153823420, 1000, 0), 10153824000)
#assert.eq(_discretize-up(0.1, 2, -2), 0.1)
#assert.eq(_discretize-up(0.23456789, 5, -8), 0.2345679)

#assert.eq(_discretize-down(1.2, 2, -7), 1.2)
#assert.eq(_discretize-down(1.2, 2, -1), 1.2)
#assert.eq(_discretize-down(0.23456789, 5, -8), 0.23456785)
#assert.eq(_discretize-down(2345.23, 2, -2), 2345.22)
#assert.eq(_discretize-down(2345.23, 2, -1), 2345.2)
#assert.eq(_discretize-down(2345.23, 2, 0), 2344)
#assert.eq(_discretize-down(2345.23, 2, 1), 2340)
#assert.eq(_discretize-down(2345.23, 2, 2), 2200)
#assert.eq(_discretize-down(2345.23, 2, 3), 2000)
#assert.eq(_discretize-down(34, 5, 0), 30)
#assert.eq(_discretize-down(1015, 11, 0), 1012)
#assert.eq(_discretize-down(10153823420, 1000, 0), 10153823000)
