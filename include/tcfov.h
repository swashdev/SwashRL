// an alternate fov.h for libtcod's implementation of the same shadowcasting
// algorithm I'm trying to implement

import global;

static void cast_light( map* to_display, int cx, int cy, int row, float start,
                        float end, int radius, int r2, int xx, int xy, int yx,
                        int yy, int id, bool light_walls);

void TCOD_map_compute_fov_recursive_shadowcasting(map* to_display,
    int player_x, int player_y, int max_radius, bool light_walls);

// even though we don't have to use preprocessor parameters in D, we should
// still declare this enum here because it has an impact on ``fov.h''
enum USE_TCOD_FOV = true;
