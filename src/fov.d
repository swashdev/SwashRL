import tcfov;
import global;

void calc_visible( map* to_display, ushort viewer_x, ushort viewer_y )
{
  TCOD_map_compute_fov_recursive_shadowcasting(
    to_display, viewer_x, viewer_y, 0, true );
}
