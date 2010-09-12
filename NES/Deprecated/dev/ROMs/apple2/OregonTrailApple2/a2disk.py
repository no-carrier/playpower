#!/usr/bin/env python

# Apple ][ DOS 3.3 disk image reader
# version 0.5
# James Tauber / jtauber.com
#
# USAGE:
#   ./a2disk.py <disk image> -- display catalog
#   ./a2disk.py <disk image> <file name> -- dump contents of file
#
# TODO:
# - different handlers for different file types
#   (including detokenizing BASIC)
# - ability to write files


import sys


MAX_HOPS = 560 # to prevent infinite loop caused by corrupt disk


def bit_count(word):
    "counts the number of on-bits in given 16-bit word"
    return sum([((word & (1<<j)) != 0x0) for j in range(0x10)])

def read_word_bigendian(buff, offset):
    return buff[offset] * 0x100 + buff[offset + 1]

def read_word_littleendian(buff, offset):
    return buff[offset] + buff[offset + 1] * 0x100


class Disk(object):
    """
    an object representing a disk image with ability to read sectors
    """
    
    TRACKS_PER_DISK = 0x23
    SECTORS_PER_TRACK = 0x10
    SECTOR_SIZE = 0x100
    
    def __init__(self, image_name):
        self.disk_image = open(image_name)
    
    def seek_sect(self, track, sector):
        if track >= Disk.TRACKS_PER_DISK or sector >= Disk.SECTORS_PER_TRACK:
            raise Exception("seek out of range")
        return self.disk_image.seek((track * Disk.SECTORS_PER_TRACK + sector) * Disk.SECTOR_SIZE)
    
    def read_sect(self, track, sector):
        self.seek_sect(track, sector)
        return [ord(x) for x in self.disk_image.read(Disk.SECTOR_SIZE)]
    
    def close(self):
        self.disk_image.close()


class VTOC(object):
    """
    knowledge of how to read the Apple ][ DOS 3.3 Volume Table of Contents.
    """
    
    # location of VTOC
    TRACK = 0x11
    SECTOR = 0x00
    
    # useful offsets into VTOC
    CATALOG_TRACK_OFFSET = 0x01
    CATALOG_SECTOR_OFFSET = 0x02
    VOLUME_NUMBER_OFFSET = 0x06
    TRACK_MAP_OFFSET = 0x38
    
    TRACK_MAP_SIZE = 0x04
    
    # offset, value pairs for validating DOS 3.3 VTOC
    VALIDATION = [
        (0x03, 0x03), # DOS version number
        (0x27, 0x7A), # max number of track/sector pairs
        (0x34, Disk.TRACKS_PER_DISK), # tracks per disk
        (0x35, Disk.SECTORS_PER_TRACK), # sectors per track
        (0x36, Disk.SECTOR_SIZE % 0x100), # bytes per sector (low)
        (0x37, Disk.SECTOR_SIZE // 0x100), # bytes per sector (high)
    ]
    
    def __init__(self, disk):
        self.disk = disk
        self.vtoc_buffer = disk.read_sect(VTOC.TRACK, VTOC.SECTOR)
        self.validate()
    
    def validate(self):
        for offset, value in VTOC.VALIDATION:
            if self.vtoc_buffer[offset] != value:
                raise Exception("not an Apple DOS 3.3 disk")
    
    def track_map(self, track):
        track_map_offset = VTOC.TRACK_MAP_OFFSET + track * VTOC.TRACK_MAP_SIZE
        return read_word_bigendian(self.vtoc_buffer, track_map_offset)
    
    @property
    def disk_volume(self):
        return self.vtoc_buffer[VTOC.VOLUME_NUMBER_OFFSET]
    
    @property
    def free_sectors(self):
        return sum([bit_count(self.track_map(track_number)) for track_number in range(0x23)])
    
    @property
    def catalog_track_sector(self):
        return self.vtoc_buffer[VTOC.CATALOG_TRACK_OFFSET], self.vtoc_buffer[VTOC.CATALOG_SECTOR_OFFSET]


class Catalog(object):
    """
    knowledge of how to read an Apple ][ DOS 3.3 Disk Catalog.
    """
    
    NEXT_TRACK_OFFSET = 0x01
    NEXT_SECTOR_OFFSET = 0x02
    
    ENTRY_OFFSET = 0x0B
    ENTRY_SIZE = 0x23
    
    FILE_TYPES = { 0x00: "T", 0x01: "I", 0x02: "A", 0x04: "B", 0x08: "S", 0x10: "R", 0x20: "a", 0x40: "b" }
    
    def __init__(self, vtoc):
        self.vtoc = vtoc
        self.disk = vtoc.disk
    
    def walk_entries(self, callback):
        """
        walks the catalog entries, calling the given callback for each one.
        
        The callback arguments are:
         - start track of track/sector list for file
         - start sector of track/sector list for file
         - whether file is locked or not
         - type of file (see FILE_TYPES)
         - size of file in sectors
         - name of file (padded to 30 characters)
         
        If the callback returns a non-False value, walking will stop and that
        value will be returned by this method.
        """
        hop = 0
        track, sector = self.vtoc.catalog_track_sector
        while track != 0x00:
            hop += 1
            if hop >= MAX_HOPS:
                raise Exception("exceeded catalog hops")
            catalog_sector = self.disk.read_sect(track, sector)
            for i in range(Catalog.ENTRY_OFFSET, 0xFF, Catalog.ENTRY_SIZE):
                buff = catalog_sector[i:]
                if buff[0x00] != 0xFF and buff[0x03] != 0x00:
                    ts_list_start_track = buff[0x00]
                    ts_list_start_sector = buff[0x01]
                    locked = buff[0x02] & 0x80
                    file_type = buff[0x02] & 0x7F
                    size = read_word_littleendian(buff, 0x21)
                    name = "".join([chr(buff[j] & 0x7F) for j in range(0x03, 0x21)])
                    result = callback(ts_list_start_track, ts_list_start_sector, locked, file_type, size, name)
                    if result:
                        return result
            track = catalog_sector[Catalog.NEXT_TRACK_OFFSET]
            sector = catalog_sector[Catalog.NEXT_SECTOR_OFFSET]


class Files(object):
    """
    knowledge of how to read an Apple ][ DOS 3.3 file from track/sector list.
    """
    
    def __init__(self, disk):
        self.disk = disk
    
    def walk_sectors(self, start_track, start_sector, callback):
        """
        walks the sectors of a file given the starting track/sector of track/sector list.
        """
        hop = 0
        track, sector = start_track, start_sector
        while track != 0x00:
            hop += 1
            if hop >= MAX_HOPS:
                raise Exception("exceeded track/sector list hops")
            track_sector_list_sector = self.disk.read_sect(track, sector)
            
            for i in range(0x0C, 0xFF, 0x02):
                file_track, file_sector = track_sector_list_sector[i:i+2]
                if file_track == 0x00 and file_sector == 0x00:
                    break
                callback(self.disk.read_sect(file_track, file_sector))
            
            track = track_sector_list_sector[0x01]
            sector = track_sector_list_sector[0x02]



## COMMAND LINE FUNCTIONS


def catalog(image_name):
    disk = Disk(image_name)
    vtoc = VTOC(disk)
    
    print
    print "Disk Volume %d, Free Blocks: %d" % (vtoc.disk_volume, vtoc.free_sectors)
    print
    
    catalog = Catalog(vtoc)
    
    def print_entry(ts_list_start_track, ts_list_start_sector, locked, file_type, size, name):
        print " %s%s %03u %s" % ("*" if locked else " ", Catalog.FILE_TYPES[file_type], size, name)
    
    catalog.walk_entries(print_entry)
    print
    
    disk.close()


def dump(image_name, file_name):
    disk = Disk(image_name)
    files = Files(disk)
    vtoc = VTOC(disk)
    catalog = Catalog(vtoc)
    
    def find_entry(find_name):
        find_name = "%-30s" % find_name # pad with spaces for match
        def callback(ts_list_start_track, ts_list_start_sector, locked, file_type, size, name):
            if name == find_name:
                return ts_list_start_track, ts_list_start_sector
        return callback
    
    result = catalog.walk_entries(find_entry(file_name))
    if result:
        track, sector = result
    else:
        raise Exception("file not found")
    
    def callback(sector_data):
        for d in sector_data:
            if d == 0x8D: # new line
                print
            else:
                sys.stdout.write(chr(d & 0x7F))
    
    files.walk_sectors(track, sector, callback)
    
    disk.close()


USAGE = """
Apple ][ DOS 3.3 disk image reader

./a2disk.py <disk image> -- display catalog
./a2disk.py <disk image> <file name> -- dump contents of file
"""


if __name__ == "__main__":
    if len(sys.argv) == 2:
        catalog(sys.argv[1])
    elif len(sys.argv) == 3:
        dump(sys.argv[1], sys.argv[2])
    else:
        print USAGE

