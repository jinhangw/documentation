import pygame

class dataset(object):

    def __init__(self, datafile, imgdir=None):
        self.imgs = {}

        with open(datafile) as f:
            data = f.read().split('\n')

        for datum in data:
            if datum == '': continue
            datum = datum.split(', ')
            print datum
            self.imgs[datum[0][:datum[0].index('.')]] = {'file' : pygame.image.load('img-data/' + datum[0]), 'coords' : (float(datum[1]), float(datum[2]))}


