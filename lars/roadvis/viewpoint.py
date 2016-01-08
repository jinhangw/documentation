class viewpoint(object):

    def __init__(self, lat, lon, blat, blon):
        self.x = 0
        self.y = 0
        self.zoom = 0
        self.set_view(lat, lon, blat, blon)

    def set_view(self, lat, lon, blat, blon):
        self.tlat = lat  # top left corner coords
        self.tlon = lon
        self.blat = blat # bottom right corner coords
        self.blon = blon
        self.v_range = abs(lat - blat)
        self.h_range = abs(lon - blon)


