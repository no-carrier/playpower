/***************************************************************************

Atari Ultra Tank video emulation

***************************************************************************/

#include "driver.h"
#include "ultratnk.h"
#include "audio/sprint4.h"

static tilemap* playfield;

static bitmap_t* helper;

int ultratnk_collision[4];


PALETTE_INIT( ultratnk )
{
	/* allocate the colortable */
	machine->colortable = colortable_alloc(machine, 4);

	colortable_palette_set_color(machine->colortable, 0, MAKE_RGB(0x00, 0x00, 0x00));
	colortable_palette_set_color(machine->colortable, 1, MAKE_RGB(0xa4, 0xa4, 0xa4));
	colortable_palette_set_color(machine->colortable, 2, MAKE_RGB(0x5b, 0x5b, 0x5b));
	colortable_palette_set_color(machine->colortable, 3, MAKE_RGB(0xff, 0xff, 0xff));

	colortable_entry_set_value(machine->colortable, 0, color_prom[0x00] & 3);
	colortable_entry_set_value(machine->colortable, 2, color_prom[0x00] & 3);
	colortable_entry_set_value(machine->colortable, 4, color_prom[0x00] & 3);
	colortable_entry_set_value(machine->colortable, 6, color_prom[0x00] & 3);
	colortable_entry_set_value(machine->colortable, 8, color_prom[0x00] & 3);

	colortable_entry_set_value(machine->colortable, 1, color_prom[0x01] & 3);
	colortable_entry_set_value(machine->colortable, 3, color_prom[0x02] & 3);
	colortable_entry_set_value(machine->colortable, 5, color_prom[0x04] & 3);
	colortable_entry_set_value(machine->colortable, 7, color_prom[0x08] & 3);
	colortable_entry_set_value(machine->colortable, 9, color_prom[0x10] & 3);
}


static TILE_GET_INFO( ultratnk_tile_info )
{
	UINT8 code = videoram[tile_index];

	if (code & 0x20)
		SET_TILE_INFO(0, code, code >> 6, 0);
	else
		SET_TILE_INFO(0, code, 4, 0);
}


VIDEO_START( ultratnk )
{
	helper = video_screen_auto_bitmap_alloc(machine->primary_screen);

	playfield = tilemap_create(machine, ultratnk_tile_info, tilemap_scan_rows, 8, 8, 32, 32);
}


VIDEO_UPDATE( ultratnk )
{
	int i;

	tilemap_draw(bitmap, cliprect, playfield, 0, 0);

	for (i = 0; i < 4; i++)
	{
		int bank = 0;

		UINT8 horz = videoram[0x390 + 2 * i + 0];
		UINT8 attr = videoram[0x390 + 2 * i + 1];
		UINT8 vert = videoram[0x398 + 2 * i + 0];
		UINT8 code = videoram[0x398 + 2 * i + 1];

		if (code & 4)
			bank = 32;

		if (!(attr & 0x80))
		{
			drawgfx(bitmap, screen->machine->gfx[1],
				(code >> 3) | bank,
				i,
				0, 0,
				horz - 15,
				vert - 15,
				cliprect, TRANSPARENCY_PEN, 0);
		}
	}

	return 0;
}


VIDEO_EOF( ultratnk )
{
	int i;
	UINT16 BG = colortable_entry_get_value(machine->colortable, 0);
	const device_config *discrete = devtag_get_device(machine, "discrete");

	/* check for sprite-playfield collisions */

	for (i = 0; i < 4; i++)
	{
		rectangle rect;

		int x;
		int y;

		int bank = 0;

		UINT8 horz = videoram[0x390 + 2 * i + 0];
		UINT8 vert = videoram[0x398 + 2 * i + 0];
		UINT8 code = videoram[0x398 + 2 * i + 1];

		rect.min_x = horz - 15;
		rect.min_y = vert - 15;
		rect.max_x = horz - 15 + machine->gfx[1]->width - 1;
		rect.max_y = vert - 15 + machine->gfx[1]->height - 1;

		sect_rect(&rect, video_screen_get_visible_area(machine->primary_screen));

		tilemap_draw(helper, &rect, playfield, 0, 0);

		if (code & 4)
			bank = 32;

		drawgfx(helper, machine->gfx[1],
			(code >> 3) | bank,
			4,
			0, 0,
			horz - 15,
			vert - 15,
			&rect, TRANSPARENCY_PEN, 1);

		for (y = rect.min_y; y <= rect.max_y; y++)
			for (x = rect.min_x; x <= rect.max_x; x++)
				if (colortable_entry_get_value(machine->colortable, *BITMAP_ADDR16(helper, y, x)) != BG)
					ultratnk_collision[i] = 1;
	}

	/* update sound status */

	discrete_sound_w(discrete, ULTRATNK_MOTOR_DATA_1, videoram[0x391] & 15);
	discrete_sound_w(discrete, ULTRATNK_MOTOR_DATA_2, videoram[0x393] & 15);
}


WRITE8_HANDLER( ultratnk_video_ram_w )
{
	videoram[offset] = data;
	tilemap_mark_tile_dirty(playfield, offset);
}
