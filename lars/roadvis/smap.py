import pygame
from pygame.locals import *

class smap(object):

    def __init__(self, *args):
        self.imgs = {}

        with open('map-data/coords') as f:
            coords = f.read().split('\n')

        for coord in coords:
            if coord == '': continue
            img = coord[:coord.index(':')]
            coord = coord[coord.index(':') + 2:].split(' || ')

            for i in xrange(len(coord)):
                coord[i] = coord[i].split('; ')
                coord[i] = (self.min_deg(coord[i][0]), self.min_deg(coord[i][1]))

            image = pygame.image.load('map-data/' + img)
            self.imgs[img[:img.index('.')]] = {'file' : image, 'topleft' : coord[0], 'bottomright' : coord[1], 'dimensions' : image.get_size(), 'scaled': False}


    def min_deg(self, s): # converts coordinates from DD,MM,SS.SS format to a
                        # floating point degree
        hem = s[s.index(' ') + 1:] # the hemisphere (N,S,E,W)
        if hem == 'S' or hem == 'W': hem = -1
        else: hem = 1
        s = s[:s.index(' ')].split(',')
        mins = float(s[2])/60 + float(s[1])

        return (float(s[0]) + mins/60) * hem

    def scale(self, img, dims):
        self.imgs[img]['file'] = pygame.transform.scale(self.imgs[img]['file']
                                                        , dims)
        self.imgs[img]['dimensions'] = dims
        self.imgs[img]['scaled'] = True
