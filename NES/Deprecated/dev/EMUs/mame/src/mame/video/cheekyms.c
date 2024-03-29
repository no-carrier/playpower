/*************************************************************************
 Universal Cheeky Mouse Driver
 (c)Lee Taylor May 1998, All rights reserved.

 For use only in offical MAME releases.
 Not to be distrabuted as part of any commerical work.
***************************************************************************
Functions to emulate the video hardware of the machine.
***************************************************************************/

#include "driver.h"
#include "sound/dac.h"


UINT8 *cheekyms_videoram;
UINT8 *cheekyms_spriteram;
UINT8 *cheekyms_port_80;

static tilemap *cheekyms_tilemap;
static bitmap_t *bitmap_buffer;

/* bit 3 and 7 of the char color PROMs are used for something -- not currently emulated -
   thus GAME_IMPERFECT_GRAPHICS */

PALETTE_INIT( cheekyms )
{
	int i,j,bit,r,g,b;

	for (i = 0; i < 6; i++)
	{
		for (j = 0;j < 0x20;j++)
		{
			/* red component */
			bit = (color_prom[0x20*(i/2)+j] >> ((4*(i&1))+0)) & 0x01;
			r = 0xff * bit;
			/* green component */
			bit = (color_prom[0x20*(i/2)+j] >> ((4*(i&1))+1)) & 0x01;
			g = 0xff * bit;
			/* blue component */
			bit = (color_prom[0x20*(i/2)+j] >> ((4*(i&1))+2)) & 0x01;
			b = 0xff * bit;

			palette_set_color(machine,(i*0x20)+j,MAKE_RGB(r,g,b));
		}
	}
}


WRITE8_HANDLER( cheekyms_port_40_w )
{
	/* the lower bits probably trigger sound samples */

	dac_data_w(devtag_get_device(space->machine, "dac"), data ? 0x80 : 0);
}


WRITE8_HANDLER( cheekyms_port_80_w )
{
	/* d0-d1 - sound enables, not sure which bit is which */
	/* d3-d5 - man scroll amount */
	/* d6 - palette select (selects either 0 = PROM M9, 1 = PROM M8) */
	/* d7 - screen flip */
	*cheekyms_port_80 = data;

	/* d2 - interrupt enable */
	interrupt_enable_w(space, offset, data & 0x04);
}



static TILE_GET_INFO( cheekyms_get_tile_info )
{
	int color;

	int x = tile_index & 0x1f;
	int y = tile_index >> 5;
	int code = cheekyms_videoram[tile_index];
	int palette = (*cheekyms_port_80 >> 2) & 0x10;

	if (x >= 0x1e)
	{
		if (y < 0x0c)
			color = 0x15;
		else if (y < 0x14)
			color = 0x16;
		else
			color = 0x14;
	}
	else
	{
		if ((y == 0x04) || (y == 0x1b))
			color = palette | 0x0c;
		else
			color = palette | (x >> 1);
	}

	SET_TILE_INFO(0, code, color, 0);
}

VIDEO_START( cheekyms )
{
	int width, height;

	width = video_screen_get_width(machine->primary_screen);
	height = video_screen_get_height(machine->primary_screen);
	bitmap_buffer = auto_bitmap_alloc(machine, width, height, BITMAP_FORMAT_INDEXED16);

	cheekyms_tilemap = tilemap_create(machine, cheekyms_get_tile_info, tilemap_scan_rows, 8, 8, 32, 32);
	tilemap_set_transparent_pen(cheekyms_tilemap, 0);
}


static void draw_sprites(gfx_element **gfx, bitmap_t *bitmap, const rectangle *cliprect, int flip)
{
	offs_t offs;

	for (offs = 0; offs < 0x20; offs += 4)
	{
		int x, y, code, color;

		if ((cheekyms_spriteram[offs + 3] & 0x08) == 0x00) continue;

		x  = 256 - cheekyms_spriteram[offs + 2];
		y  = cheekyms_spriteram[offs + 1];
		code =  (~cheekyms_spriteram[offs + 0] & 0x0f) << 1;
		color = (~cheekyms_spriteram[offs + 3] & 0x07);

		if (cheekyms_spriteram[offs + 0] & 0x80)
		{
			if (!flip)
				code++;

			drawgfx(bitmap, gfx[1], code, color, 0, 0, x, y, cliprect, TRANSPARENCY_PEN, 0);
		}
		else
		{
			if (cheekyms_spriteram[offs + 0] & 0x02)
			{
				drawgfx(bitmap, gfx[1], code | 0x20, color, 0, 0,        x, y, cliprect, TRANSPARENCY_PEN, 0);
				drawgfx(bitmap, gfx[1], code | 0x21, color, 0, 0, 0x10 + x, y, cliprect, TRANSPARENCY_PEN, 0);
			}
			else
			{
				drawgfx(bitmap, gfx[1], code | 0x20, color, 0, 0, x,        y, cliprect, TRANSPARENCY_PEN, 0);
				drawgfx(bitmap, gfx[1], code | 0x21, color, 0, 0, x, 0x10 + y, cliprect, TRANSPARENCY_PEN, 0);
			}
		}
	}
}


VIDEO_UPDATE( cheekyms )
{
	int y,x;
	int scrolly = ((*cheekyms_port_80 >> 3) & 0x07);
	int flip = *cheekyms_port_80 & 0x80;

	tilemap_mark_all_tiles_dirty(ALL_TILEMAPS);
	tilemap_set_flip(ALL_TILEMAPS, flip ? TILEMAP_FLIPX | TILEMAP_FLIPY : 0);

	bitmap_fill(bitmap, cliprect, 0);
	bitmap_fill(bitmap_buffer, cliprect, 0);

	/* sprites go under the playfield */
	draw_sprites(screen->machine->gfx, bitmap, cliprect, flip);

	/* draw the tilemap to a temp bitmap */
	tilemap_draw(bitmap_buffer, cliprect, cheekyms_tilemap, 0, 0);

	/* draw the tilemap to the final bitmap applying the scroll to the man character */
	for(y = cliprect->min_y; y <= cliprect->max_y; y++)
	{
		for(x = cliprect->min_x; x <= cliprect->max_x; x++)
		{
			int in_man_area;

			if(flip)
			{
				in_man_area = (x >= (32-12-1)*8 && x < (32-8)*8 && y > 5*8 && y < 27*8);
			}
			else
			{
				in_man_area = (x >= 8*8 && x < 12*8 && y > 5*8 && y < 27*8);
			}

			if(in_man_area)
			{
				if ((y + scrolly) < 27*8 && *BITMAP_ADDR16(bitmap_buffer, y + scrolly, x) != 0)
					*BITMAP_ADDR16(bitmap, y, x) = *BITMAP_ADDR16(bitmap_buffer, y + scrolly, x);
			}
			else
			{
				if(*BITMAP_ADDR16(bitmap_buffer, y, x) != 0)
					*BITMAP_ADDR16(bitmap, y, x) = *BITMAP_ADDR16(bitmap_buffer, y, x);
			}
		}
	}


	return 0;
}
