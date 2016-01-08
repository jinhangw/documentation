import pygame, sys, math
from pygame.locals import *
from viewpoint import *
from smap import *
from imagedata import *


pygame.init()

(s_w, s_h) = pygame.display.list_modes()[0]
s_dimen = (s_w, s_h)

FPS = 40
clock = pygame.time.Clock()

screen = pygame.display.set_mode(s_dimen)
pygame.display.toggle_fullscreen()

font = pygame.font.Font(pygame.font.match_font('Monospace'), 12)

def draw_text(text, top, left):
    text= font.render(text, True, (0, 0, 0), (255, 255, 255))
    text_r = text.get_rect()
    text_r.top = top
    text_r.left = left
    screen.blit(text, text_r)

def dist(p1, p2):
    return math.sqrt((p1[0]-p2[0]) ** 2 + (p1[1]-p2[1]) ** 2)

def main():
    running = True
    s = smap()
    s.scale('sc1', s_dimen)
    v = viewpoint(s.imgs['sc1']['topleft'][0], s.imgs['sc1']['topleft'][1], s.imgs['sc1']['bottomright'][0], s.imgs['sc1']['bottomright'][1])
    data = dataset(sys.argv[1])
    while running:
        m_pos = pygame.mouse.get_pos()
        lat = v.tlat + (float(m_pos[1])/s_h) * v.v_range
        lon = v.tlon + (float(m_pos[0])/s_w) * v.h_range
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            if event.type == pygame.KEYDOWN:
                if event.key == K_ESCAPE:
                    running = False
        for img in s.imgs:
            screen.blit(s.imgs[img]['file'], (0, 0))
        for datum in data.imgs:
            ypos = ((data.imgs[datum]['coords'][0] - v.tlat)/v.v_range) * s_h
            xpos = ((data.imgs[datum]['coords'][1] - v.tlon)/v.h_range) * s_w
            print xpos, '->', s_w, '    ', ypos, '->', s_h
            pygame.draw.circle(screen, (0, 0, 0), (xpos, ypos), 4)
            pygame.draw.circle(screen, (255, 0, 0), (xpos, ypos), 2)
            if dist((xpos,ypos), m_pos) < 10:
                screen.blit(data.imgs[datum]['file'] , (xpos, ypos))
        draw_text(str((lat, lon)), 0, 0)
        pygame.display.flip()

if __name__ == '__main__':
    main()
