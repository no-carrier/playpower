/*****************************************************************************************

 Speed Attack video hardware emulation

*****************************************************************************************/
#include "driver.h"

static tilemap *bg_tilemap;

/*

Color prom dump(only 0x00-0x10 range has valid data)
0:---- ---- 0x00 Black
1:---- -x-- 0x04
2:---- -xxx 0x07
3:x-x- -xxx 0xa7
4:--x- x--- 0x28
5:xxxx x--- 0xf8
6:--xx xxxx 0x3f
7:xxxx xxxx 0xff White
8:x--- -x-- 0x84
9:x-x- xx-x 0xad
a:--x- -x-x 0x25
b:-xxx xxx- 0x7e
c:--x- xxxx 0x2f
d:xx-- ---- 0xc0
e:--xx -xx- 0x36
f:xxx- x--- 0xe8

*/

PALETTE_INIT( speedatk )
{
	int i;

	/* allocate the colortable */
	machine->colortable = colortable_alloc(machine, 0x10);

	/* create a lookup table for the palette */
	for (i = 0; i < 0x10; i++)
	{
		int bit0, bit1, bit2;
		int r, g, b;

		/* red component */
		bit0 = (color_prom[i] >> 0) & 0x01;
		bit1 = (color_prom[i] >> 1) & 0x01;
		bit2 = (color_prom[i] >> 2) & 0x01;
		r = 0x21 * bit0 + 0x47 * bit1 + 0x97 * bit2;

		/* green component */
		bit0 = (color_prom[i] >> 3) & 0x01;
		bit1 = (color_prom[i] >> 4) & 0x01;
		bit2 = (color_prom[i] >> 5) & 0x01;
		g = 0x21 * bit0 + 0x47 * bit1 + 0x97 * bit2;

		/* blue component */
		bit0 = 0;
		bit1 = (color_prom[i] >> 6) & 0x01;
		bit2 = (color_prom[i] >> 7) & 0x01;
		b = 0x21 * bit0 + 0x47 * bit1 + 0x97 * bit2;

		colortable_palette_set_color(machine->colortable, i, MAKE_RGB(r, g, b));
	}

	/* color_prom now points to the beginning of the lookup table */
	color_prom += 0x20;

	for (i = 0; i < 0x100; i++)
	{
		UINT8 ctabentry = color_prom[i] & 0x0f;
		colortable_entry_set_value(machine->colortable, i, ctabentry);
	}
}

WRITE8_HANDLER( speedatk_videoram_w )
{
	videoram[offset] = data;
	tilemap_mark_tile_dirty(bg_tilemap, offset);
}

WRITE8_HANDLER( speedatk_colorram_w )
{
	colorram[offset] = data;
	tilemap_mark_tile_dirty(bg_tilemap, offset);
}

WRITE8_HANDLER( speedatk_videoregs_w )
{
	static UINT8 address;

	if(offset == 0)
		address = data;
	else
	{
		switch(address)
		{
			/*temporary hook-up.*/
			case 0x0d:
				flip_screen_set(space->machine, data & 8);
				tilemap_set_scrolldx(bg_tilemap,0,data & 0x40);
				break;
			default:
				logerror("Video Register %02x called with %02x data\n",address,data);
		}
	}
}

static TILE_GET_INFO( get_tile_info )
{
	int code, color, region;

	code = videoram[tile_index] + ((colorram[tile_index] & 0xe0) << 3);
	color = colorram[tile_index] & 0x1f;
	region = (colorram[tile_index] & 0x10) >> 4;

	SET_TILE_INFO(region, code, color, 0);
}

VIDEO_START( speedatk )
{
	bg_tilemap = tilemap_create(machine, get_tile_info,tilemap_scan_rows,8,8,34,32);
}

VIDEO_UPDATE( speedatk )
{
	tilemap_draw(bitmap,cliprect,bg_tilemap,0,0);
	return 0;
}
