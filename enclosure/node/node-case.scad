// SPDX-License-Identifier: CERN-OHL-P-2.0
// thesada node case: base carrier v0.2 at the bottom, a top board on its headers:
// LILYGO T-SIM7080G-S3 on long stacking pins, or a Freenove FNK0085. Units mm.
// Frame: carrier outline origin in XY, z = 0 is the case back.
// Render: make -C enclosure/node stl png, make -C enclosure/node stl-freenove png-freenove

variant = "lilygo";           // [lilygo, freenove] top board, sets the length, height and the board-specific parts
part = "assembly"; // [assembly, exploded, inside, section, section_board, gland_wall, gland_wall_in, dcjack_adapter_view, body, lid_with_label_recess, label_insert, lid_solid, gasket, gland_grommet, gland_cap, jack_boot, jack_cap, dcjack_adapter, dcjack_adapter_gasket, ear_magnet_adapter, ear_adapter_back, ear_adapter_side, body_magnets, body_magnets_back, modifier_inserts, modifier_carrier_mounts, modifiers, coupon_body, coupon_lid, coupon_gasket, insert_test, insert_test_fine, insert_test_fine_small, dcjack_section, dcjack_inside]

/* [Carrier, from its design files (see README)] */
car_w = 76.2;                 // carrier outline, Gerber_BoardOutlineLayer.GKO
car_l = 63.5;
car_pcb = 1.59;               // carrier board solid in the STEP model
car_holes = [[4.064, 4.064], [72.136, 4.064], [4.064, 59.436], [72.136, 59.436]]; // NPTH 3.2
car_hole_d = 3.2;
car_hdr_h = 8.5;              // U1_A1/U1_A2 female header body, KH-2.54FH-1X16P-H8.5
car_conn_h = 7.0;             // tallest carrier part: XH 3-pin J1B/J2B/J3A-D, STEP model
jack_y = [14.48, 29.46];      // J2A, J1A (PJ-307C, CT inputs) on the x = 0 edge, pick-and-place
jack_front = -2.9;            // barrel face, STEP (body front at -1.4)
jack_zc = 2.5;                // barrel centre above the carrier top, STEP
jack_barrel_d = 6;

/* [LILYGO, from the vendor DXF and STEP] */
lily_x0 = -2.047; lily_x1 = 30.846; lily_len = 110.541;
lily_holes = [[0.544, 2.286], [28.256, 2.286], [0.544, 107.874], [28.256, 107.874]];
lily_hole_d = 2.0;
// Both boards face up, the LILYGO turned 180 deg (pin 1 of each row by net name). Carrier = [a - x, b - y].
lily_a = 59.10;               // header rows: LILYGO x -0.7/29.5, carrier x 29.46/59.94
lily_b = 118.05;              // LILYGO pin 1 y 67.0 lands on carrier U1_A1 pin 1 y 51.05
lily_pcb = 1.2;               // board thickness, STEP
lily_top_h = 8.0;             // tallest top part 5.0 (PH2.0 connector, STEP) plus u.FL cables
// stick-on heatsinks on the LILYGO top: [x, y] centre in LILYGO coordinates, [w, l] footprint, part height under it
// ESP32-S3 module 18 x 25.5 x 3.1 (STEP), SIM7080G 17.6 x 15.7 x 2.3 (datasheet), AXP2101 PMU 4 x 4 x 0.9.
// Centres of the SIM7080G and the PMU are read off the vendor pinout image: check with calipers
heatsinks = [[[14.4, 97.7], [20, 20], 3.1], [[15.4, 19.5], [14, 14], 2.3], [[15.4, 50.0], [9, 9], 0.9]];
hs_h = 6.0;                   // heatsink height, the common 14 x 14 x 6 and 20 x 20 x 6 kits
usb_c_xy = [61.33, 58.85];    // USB-C mouth faces +x: x from the STEP, y from the DXF footprint
usb_z = 1.58;                 // USB-C centre above the LILYGO top (3.15 tall), STEP
ipex_lte = [36.5, 116.55];    // ANT_146
bat_xy = [43.6, 61.08];       // 18650 holder centre, STEP (Keystone 1042, LILYGO underside)
bat_holder = [20.65, 77.05, 15.15]; // holder x, y, depth below the board, STEP
cell = [19.88, 65.3];         // 18650 cell diameter and length, STEP
bat_h = 19.4;                 // LILYGO underside to the lowest point of the cell, STEP

/* [Freenove FNK0085 ESP32-S3-WROOM board, from the vendor 3D model (see README)] */
// Model: Freenove_Media_Kit_for_ESP32-S3, 3D_Models/FNK0102A/3D_Shell_ESP32-S3/CB8201_OV3660.STL, same board and
// pinout as Freenove_ESP32_S3_WROOM_Board/ESP32S3_Pinout.png. Board frame: USB end y 0, left row (3V3..5V) x 1.27
fre_pcb_wl = [27.94, 51.01, 0.21];  // PCB x 0 to 27.94, y 0.21 to 51.01 (1.1 x 2.0 in), model
fre_pcb = 1.69;               // board thickness, model z 58.80 to 60.49: check: calipers
fre_rows = [1.27, 26.67];     // pin rows x, 25.4 apart, 20 pins each at 2.54 from y 1.48 (5V and GND end), model
fre_pin1_y = 1.478;
fre_spacer = 2.54;            // male header plastic under the PCB, model z 56.26 to 58.80. Pins 5.6 below it
fre_bot_h = 1.94;             // deepest underside part past the headers (SD slot), model z 56.86
// ESP32-S3-WROOM-1 18 x 25.5 x 3.1: substrate x 4.95 to 22.95, y 31.70 to 57.20, shield top 3.1 above the PCB.
// The PCB antenna end (y 50.35 to 57.20) overhangs the board edge by 6.2 mm, model and Espressif datasheet
fre_module = [[4.95, 31.70], [22.95, 57.20], 3.1];
fre_ant_y0 = 50.35;           // shield end, antenna area starts
fre_usb = [[3.59, 13.17], [14.77, 24.35]];  // two USB-C, x ranges, y 0.01 to 7.54, mouths face -y. Model
fre_usb_y1 = 7.54;
fre_usb_z = [-0.91, 3.25];    // shell bottom and top against the PCB top, model z 59.58 to 63.74
fre_buttons = [[4.11, 10.78], [20.88, 10.78]];  // EN and BOOT, 3 x 4 x 1.36 above the PCB, model
fre_top_h = 9.03;             // tallest top part: the OV3660 camera on its FPC over the module, model. USB-C alone 3.25
// both boards face up, the Freenove turned 180 deg: carrier = [a - x, b - y]. Rows land on U1_B2/U1_B1 (x 32.004/57.404,
// 20 pins, PickAndPlace.csv), pin 1 by net: U1_B1-1 VSYS is the 5V pin, U1_B2-1 TXD, U1_B2-20 GND (Netlist.tel)
fre_a = 57.404 + 1.27;
fre_b = 51.054 + 1.478;
fre_heatsinks = [];           // none by default: no modem or PMU. ESP32-S3 shield: [[[13.95, 41.55], [14, 14], 3.1]]
fre_hold = false;             // lid rib over both USB-C shells. Off: 31 tall under a 53 body it breaks, the 40 header pins hold the board
fre_hold_gap = 0.5;           // rib to the USB-C shell tops with the lid on
fre_hold_t = 2.4;
// DC jack in the end wall away from the PCB antenna, x between the PG7 locknut and the USB-C plug path (derived below)
dcjack_fre = true;
fre_usb_plug = [12.35, 6.5];  // USB-C plug overmold max width and thickness (USB Type-C spec), kept clear from the mouth to the wall
pwr_in_xy = [4.064, 51.054];  // PWR_IN B2B-XH-A 2-pin, rotated 270, PickAndPlace.csv
fre_mag_pos = [[8, 22], [38.1, 22], [68.2, 22], [8, 45], [38.1, 45], [68.2, 45]];

/* [Measure these with calipers] */
stack_gap = 30.0;             // carrier top to LILYGO underside, calipers 29.8 to 30: design for the upper bound
plug_h = 7.0;                 // mated XH plug above the header, calipers
wire_bend = 5.0;              // wire bend allowance above the plug, about 3x the 22 AWG wire
car_top_h = car_conn_h + plug_h + wire_bend;  // XH header, plug and bent wires above the carrier top
plug_d = 8.8;                 // calipers: ribbed body, no thread. Boot bore 0.4 under for a light squeeze
cable_d = 4.0;                // calipers: DS18B20 probe cable outer diameter

/* [Look] */
r_v = 8.0;                    // vertical edge radius
r_lid = 2.5;                  // lid top edge radius
back_chamfer = 1.0;           // 45 deg chamfer on the back edge
label_w = 56;                 // lid recess for a label or logo, 0 depth = none
label_l = 30;
label_r = 4;
label_depth = 0.6;

/* [Shell] */
wall = 2.4;
floor_t = 2.4;
clear = 4.0;                  // board envelope to the inner rim edge, sized so the carrier corners pass the corner rim
lid_h = 6.0;                  // lid above the seal face
lid_t = 2.4;                  // lid plate over the pocket
lip_t = 2.0;                  // lid skirt over the seam, the drip edge
lip_gap = 0.4;
lip_h = 3.0;
car_so = 5.0;                 // carrier standoffs, clear of its through-hole pins (3.3)

/* [Seal] */
groove_w = 3.2;               // groove width, the gasket follows it
tpu_shore = 95;               // [95, 90, 85, 82] TPU hardness, sets compression and gasket width
g_h = 2.2;
groove_wall = 2.0;
groove_d = 3.0;
Rg = 17;                      // groove corner radius, leaves room for the insert bosses outside it

/* [Screws: M3 from the top through the lid into M3 x 5.7 heat-set inserts in the body corners] */
m3_clear = 3.4;
m3_len = 12;                  // DIN 912 socket head. Lid insert 8 + lid clamp 2.8 = 10.8 minimum, so buy M3 x 12 (M3 x 16 for a 10 mm lid insert)
m3_head_d = 5.5;              // DIN 912
m3_head_h = 3.0;
cb_d = 6.2;                   // head counterbore in the lid top, printed face down on sequential bridges
cb_h = 3.2;
layer_h = 0.2;                // one bridge layer each for the slot and the square over the counterbore
// CNC Kitchen: straight holes, not tapered, just large enough that the tip enters, test 4.0 to 4.4,
// https://www.cnckitchen.com/blog/tipps-amp-tricks-fr-gewindeeinstze-im-3d-druck-3awey
material = "pla";             // [pla, petg, abs]
lid_insert = "m3_small";      // [m3_large, m3_small] insert in the 4 corner lid columns. m3_large seats at 4.35 in PLA, m3_small is the cheaper set marked m3x4x4.2
pcb_insert = "m3_small";      // [m3_large, m3_small] insert in the carrier standoffs
lid_ins_len = 8;              // [4, 6, 8, 10] lid column insert length. m3_small comes in 4, 6, 8, 10, m3_large only in 4
pcb_ins_len = 4;              // [4, 6, 8, 10] carrier standoff insert length
// ins_d table, one place. Only m3_large/pla is measured, all others are estimates or placeholders, check: print the fine coupon
//   m3_large/pla and m3_large/petg 4.35 measured. m3_large/abs 4.35 placeholder, check: coupon
//   m3_small/petg 4.15 measured. m3_small/pla 4.15 not measured, check: insert_test_fine_small. m3_small/abs 4.15 placeholder, check: coupon
ins_tbl = [["m3_large", "pla", 4.35], ["m3_large", "petg", 4.35], ["m3_large", "abs", 4.35],
           ["m3_small", "pla", 4.15], ["m3_small", "petg", 4.15], ["m3_small", "abs", 4.15]];
function ins_d_of(i) = let(h = [for (r = ins_tbl) if (r[0] == i && r[1] == material) r[2]]) assert(len(h) == 1, str("no ins_d for insert ", i, " in ", material)) h[0];
ins_d = ins_d_of(lid_insert);
ins_chamfer = 0.6;            // 45 deg lead-in at the mouth of every insert hole, cone from ins_d + 2 x this down to ins_d
ins_l = lid_ins_len;
// m3_large: OD over the knurl about 5.0 (measured) and length 4 only. m3_small: marking m3x4x4.2, 4.2 OD
ins_od = lid_insert == "m3_small" ? 4.2 : 5.0;     // preview only, no assert uses it
ins_hole_l = lid_ins_len + 6.5;   // lid column pocket: insert plus room for the screw tip
ins_wall = lid_insert == "m3_small" ? 2.0 : 1.9;   // boss wall round the insert hole, makers ask for 1.6 or more. 2.0 fails the corner screw room assert (D 12.21) at m3_large 4.35 and 4.4, fits at m3_small 4.15
lily_pilot = 1.7;             // M2 self-tapping into the LILYGO standoffs (vendor shell: 1.7 too)
car_ins_h = pcb_ins_len + 2;  // carrier standoff pocket, 6 at the default 4
car_ins_d = ins_d_of(pcb_insert);   // hole in the carrier standoffs, from the table

/* [Openings] */
gland = "pg7";                // [pg7, m12, printed]
gland_zc = 13;                // gland and vent centre above the floor, one gland row
// every probe gland on the wall nearest J3A-D, between the corner screw columns: one row at the wanted pitch
// as close to J3A-D as it goes, else two staggered rows spread evenly. Wall -1/+1 bottom/top, -2/+2 left/right
gland_side = 2;               // [-2, -1, 1, 2] right wall (x max), J3A-D at x 68.58
gland_n = 4;
gland_zc_lo = 11;             // lower row of two, locknut 0.5 off the floor
gland_wrench = 4;             // gap between neighbouring locknut corner circles, spanner margin
jack_port = true;             // recessed port panel for J1A/J2A on the left wall, TPU boots or caps
port_cb_d = 11;               // boot seat around each jack barrel
vent = true;                  // hole for an adhesive ePTFE vent, patch inside
vent_d = 3.5;
vent_x = 38.1;
vent_patch_d = 12;            // adhesive ePTFE patch inside over the vent, a guess: check: calipers
gland_nut_ac = 21;            // PG7 polyamide locknut: 19 across flats, 21 across corners, 5 thick (Altech, Weidmueller)
pg7_nut_h = 5;
// panel-mount DC barrel jack in the gland wall above the vent, nut inside. Double-D hole, flats vertical
dcjack = true;
dcjack_d = 7.8;               // threaded body, calipers
dcjack_flat = 6.8;            // across the two flats, calipers
dcjack_clear = [0.3, 0.2];    // hole clearance on the diameter and across the flats
dcjack_zc = 25.5;             // Freenove end wall: centre above the floor. LILYGO: port wall, derived
dcjack_thread = 9;            // thread length under the flange, a guess: check: calipers
dcjack_nut = [11, 2];         // nut across corners and thickness, check: calipers
dcjack_flange_d = 11;         // front flange outside, a guess: check: calipers
dcjack_depth = 14;            // thread and solder lugs behind the outer wall face, a guess: check: calipers
// dcjack_adapter: the jack in a PG7 knockout of an already printed case. Hex boss outside with a nut slot,
// PG7 thread through the wall for the locknut. Printed upright, boss face on the bed
ad_af = 17;                   // boss across flats, the flat TPU gasket under it
ad_plate = 2.0;               // boss front plate with the double-D cut
ad_back = 1.6;                // boss behind the nut slot
ad_gasket_t = 1.5;
ad_thread_d = 12.2;           // printed PG7 major, 0.3 under nominal 12.5 for the locknut: check: test-fit
ad_pitch = 1.27;              // PG7, 20 tpi
ad_depth = 0.5;               // flank depth, 42 deg flanks (PG is 80 deg included) so it prints without support
// knockouts: every gland hole, the vent and the DC jack stay closed by a membrane on the inside face
knockout = true;
ko_t = 0.8;                   // membrane, two 0.4 perimeters
ko_ring_t = 0.45;             // one perimeter round the edge, where it tears
ko_ring_w = 0.8;              // 0 = no weakened ring
lte_antenna = "lid";          // [lid, sma] lid: flex glued under the lid. sma: external antenna in the SMA knockout
// SMA bulkhead knockout in the top wall, always cut, for an u.FL to SMA pigtail. 1/4-36 UNS thread (6.35)
sma_d = 6.6;
sma_cl_d = 11;                // nut (8 across flats, 9.2 across corners) and lock washer, clearance on both faces
sma_depth = 12;               // body and pigtail crimp behind the inner face, a guess: check: calipers
// GNSS patch faces up under the lid, in the strip no board covers (x < 28), far from the carrier ground.
// LTE flex lies flat on the right inner wall, 10 mm or more from every metal part (asserted below)
gps_patch = [25, 25, 7];      // x, y, thickness. 25 x 25 from Daniel, 7 measured by Daniel 2026-11-26
gps_xy = [10.8, 96];          // centre, case frame, as far from the LILYGO edge as the lid pocket allows
gps_metal = 7;                // GNSS patch to the nearest metal, the lid height follows it
lte_fpc = [110, 20, 0.4];     // length along y, width, thickness. 110 x 20 test-fitted by Daniel, 0.4 or less, measured by Daniel 2026-11-26
lte_seat_h = 2;               // corner locators for the flex, glued like the GNSS patch
ant_gap = 10;                 // wanted gap to metal (inserts, screws, battery, board ground)
ipex_gnss = [30.0, 116.55];   // check: GNSS u.FL position on the LILYGO, assumed next to the LTE u.FL

/* [Wall mount] */
ear_w = 22;
ear_out = 16;
ear_t = 4;
ear_fillet = 6;
ear_slot_d = 4.5;
ear_slot_len = 4;

/* [Magnets: 10 x 2 mm N52 discs, press fit, pockets open to the back] */
mag_h = 2;
mag_hole = 10.1;              // press fit on a 10.0 disc, check: calipers and a test print
mag_sink = 0.1;               // pocket depth past the magnet: pressed in on a flat plate it sits flush, bottomed 0.1 below
mag_floor = 1.2;              // material over each pocket, asserted 1.2 or more
mag_web = 1.6;                // between two pockets
// ear_magnet_adapter: a shoe over a printed ear, held by a screw through the ear slot, flanges beside it
ad_mag_n = 6;                 // pockets per adapter, even, half on each side of the ear
ad_mag_u0 = 17;               // first pocket centre from the ear centre line
ad_mag_v = 11.5;              // pocket row out from the case wall, past the ear fillets
ad_clr = 0.3;                 // shoe cavity round the ear outline
ad_clr_z = 0.1;               // cap underside above the ear top, so the flange always reaches the sheet
ad_skirt = 2.4;               // shoe wall round the ear
ad_cap = 3.0;                 // shoe plate over the ear
ad_wall_gap = 0.3;            // shoe and flange to the case wall
ad_screw = [4.8, 6.5];        // ST4.8 x 6.5 pan head self-tapping (DIN 7981), cuts into the 4.5 slot walls
ad_screw_hole = 5.0;
// next version: magnets in the case back. Count = len(mag_pos), positions in the case frame
magnets = false;
mag_pos = [[8, 22], [38.1, 22], [68.2, 22], [8, 45], [38.1, 45], [68.2, 45],
           [8, 82], [38.1, 82], [68.2, 82], [8, 105], [38.1, 105], [68.2, 105]];
mag_pad_wall = 1.6;           // inside pad round each pocket, carries the floor over it

/* [Test coupon] */
coupon_h = 42;
explode = 45;
// insert_test: one straight hole per size, same chamfer and depth as the case, labels debossed on top
ins_test_d = [4.0, 4.2, 4.4];
ins_test_fine_small = [4.1, 4.15, 4.2];   // insert_test_fine_small, round the 4.2 that fits and the 4.3 that is loose
ins_test_fine = [4.3, 4.35, 4.4];   // insert_test_fine, between the 4.2 that refused and the 4.4 that seats
ins_test_pitch = 10;
ins_test_txt = 3.2;           // label cap height
ins_test_deboss = 0.6;        // three 0.2 layers
ins_test_floor = 1.2;         // under the deepest hole

$fn = 64;

// ---------- derived ----------
is_lily = variant == "lilygo";
eps = 1e-6;
assert(is_lily || variant == "freenove", str("unknown variant: ", variant));
function fre_pt(p) = [fre_a - p[0], fre_b - p[1]];  // Freenove board frame to the case frame
fre_ant_box2 = [fre_pt([fre_module[1][0], fre_module[1][1]]), fre_pt([fre_module[0][0], fre_ant_y0])];
// board envelope along y: the LILYGO reaches past the carrier top edge, the Freenove antenna past its bottom edge
env_y0 = is_lily ? 0 : min(0, fre_ant_box2[0][1]);
env_l = is_lily ? lily_b : max(car_l, fre_b - fre_pcb_wl[2]) - env_y0;
top_gap = is_lily ? stack_gap : car_hdr_h + fre_spacer;   // carrier top to the top board underside
top_pcb = is_lily ? lily_pcb : fre_pcb;
top_h = is_lily ? lily_top_h : fre_top_h;
top_hs = is_lily ? heatsinks : fre_heatsinks;
top_a = is_lily ? lily_a : fre_a;
top_b = is_lily ? lily_b : fre_b;
top_pts = is_lily ? [for (h = lily_holes) [lily_a - h[0], lily_b - h[1]]] : [];
lte_on = is_lily && lte_antenna == "lid";
gps_on = is_lily;
dcj_on = is_lily ? dcjack : dcjack_fre;
mag_xy = is_lily ? mag_pos : fre_mag_pos;
g_comp = tpu_shore >= 95 ? 0.12 : tpu_shore >= 90 ? 0.15 : tpu_shore >= 85 ? 0.20 : 0.25;  // compression at the hard stop
g_w = round(10 * 0.885 * groove_w * (1 - g_comp)) / 10;   // widest 0.1 step that keeps the closed groove under 90 % full
g_play = (groove_w - g_w) / 2;                    // side play per side
tongue_w = g_w + 0.4;
g_squeezed = g_h * (1 - g_comp);
tongue_h = groove_d - g_squeezed;
rim_in = lip_t + lip_gap;
s_g = rim_in + groove_wall + groove_w / 2;
ledge_in = rim_in + 2 * groove_wall + groove_w;
Rl = Rg - groove_w / 2 - groove_wall;
m = clear + ledge_in;
W = ceil(car_w + 2 * m);
L = ceil(env_l + 2 * m);
cx = car_w / 2;
cy = env_y0 + env_l / 2;
lid_pocket = lid_h - lid_t;

z_car_bot = floor_t + car_so;
z_car_top = z_car_bot + car_pcb;
z_top_bot = z_car_top + top_gap;
z_top_top = z_top_bot + top_pcb;
z_jack = z_car_top + jack_zc;
hs_top = len(top_hs) > 0 ? max([for (h = top_hs) h[2]]) + hs_h : 0;  // tallest heatsink top above the top board
clamp = lid_h - cb_h;                              // lid under the screw head
screw_in = m3_len - clamp;                         // screw below the seal face
diag_c = r_v * sqrt(2) - (r_v - wall);
diag_l = (s_g + Rg) * sqrt(2) - Rl;
ch_h = max(ledge_in - wall, diag_l - diag_c);      // keeps the rim ledge at 45 deg or less
// corner screws, outside the seal line
u = [1, 1] / sqrt(2);
Co = [W / 2 - r_v, L / 2 - r_v];
Cg = [W / 2 - s_g - Rg, L / 2 - s_g - Rg];
Pg = Cg + Rg * u;
Po = Co + r_v * u;
D = norm(Po - Pg);
need_in = groove_w / 2 + ins_wall + ins_d / 2;
need_out = rim_in + ins_wall + ins_d / 2;
S0 = Pg + (need_in + (D - need_in - need_out) / 2) * u;
screws = [for (sx = [-1, 1], sy = [-1, 1]) [cx + sx * S0[0], cy + sy * S0[1]]];
r_col = ins_d / 2 + ins_wall;
// probe glands, see gland_side. gl: [pos along the wall, wall, centre above the floor]
xh_y = [17.78, 24.13, 30.48, 36.83];               // J3A-D, PickAndPlace.csv
gl_ax = abs(gland_side) == 2 ? [cy, S0[1]] : [cx, S0[0]];
gl_xh = abs(gland_side) == 2 ? (xh_y[0] + xh_y[3]) / 2 : 68.58;
gl_pocket_r = gland_nut_ac / 2 + 0.5;               // locknut spot face in the rim chamfer, as for the DC jack nut
gl_lim = [gl_ax[0] - gl_ax[1] + r_col + 1 + gl_pocket_r, gl_ax[0] + gl_ax[1] - r_col - 1 - gl_pocket_r];
gl_pitch = gland_nut_ac + gland_wrench;
gl_one = gl_lim[1] - gl_lim[0] >= (gland_n - 1) * gl_pitch - eps;
gl_p = gl_one ? gl_pitch : (gl_lim[1] - gl_lim[0]) / (gland_n - 1);
gl_u0 = gl_one ? min(max(gl_xh - (gland_n - 1) * gl_p / 2, gl_lim[0]), gl_lim[1] - (gland_n - 1) * gl_p) : gl_lim[0];
gl_dz = gl_one ? 0 : ceil(10 * sqrt(pow(gl_pitch, 2) - pow(gl_p, 2))) / 10;
gl = [for (i = [0:gland_n - 1]) [gl_u0 + i * gl_p, gland_side, gl_one ? gland_zc : gland_zc_lo + (i % 2) * gl_dz]];
function g_zc(g) = g[2];
gl_zc_max = max([for (g = gl) g_zc(g)]);

// body height: boards and heatsinks under the lid, XH plugs, PG7 locknut and DC jack spot face under the rim chamfer
hb_boards = max(z_top_top + max(top_h, hs_top), z_car_top + car_top_h) + 2 - lid_pocket;
// freenove: a locknut above the rim chamfer start gets a spot face cut into the chamfer, the same rule as the DC jack nut
hb_gland = floor_t + gl_zc_max + min(gland_nut_ac / 2 + ch_h, gl_pocket_r * sqrt(2) + 1) + groove_d + 1.2;
x_o = cx - W / 2;                                 // outer face of the left wall
x_w = x_o + wall;                                 // inner face
x_pi = jack_front + 1.5 - 0.2;                    // panel inner face, 0.2 before the jack bodies
x_po = x_pi - wall;                               // panel outer face
port_y = [min(jack_y) - 9, max(jack_y) + 9];
// DC jack. LILYGO: left wall beside the port panel, past the PWR_IN plug, its nut 1 mm over the carrier parts
dcj_r = dcjack_nut[0] / 2;
dcj_z = is_lily ? z_car_top + car_conn_h + 1 + dcj_r : floor_t + dcjack_zc;
hb_dcj = dcj_on ? dcj_z + (dcj_r + 0.5) * sqrt(2) + 1 + groove_d + 1.2 : 0;
// GNSS patch against the lid ceiling, gps_metal from the LILYGO board edge
gps_dx = lily_a - 30.846 - (gps_xy[0] + gps_patch[0] / 2);
hb_gps = is_lily ? z_top_top + sqrt(max(0, pow(gps_metal, 2) - pow(gps_dx, 2))) + gps_patch[2] - lid_pocket : 0;
Hb = ceil(max(hb_boards, hb_gland, hb_dcj, hb_gps) - eps);


// ---------- antenna placement and keep-outs ----------
function gap1(a0, a1, b0, b1) = max(a0 - b1, b0 - a1, 0);
function boxgap(a, b) = norm([for (i = [0:2]) gap1(a[0][i], a[1][i], b[0][i], b[1][i])]);
// lid pocket outline (ledge2 less the 0.5 lid offset) shrunk by m: is the point inside
function in_pocket(x, y, m) = let(
  hx = W / 2 - s_g - groove_w / 2 - groove_wall - 0.5 - m, hy = L / 2 - s_g - groove_w / 2 - groove_wall - 0.5 - m,
  r = Rl - 0.5 - m, ax = abs(x - cx), ay = abs(y - cy))
  ax <= hx && ay <= hy && (ax <= hx - r || ay <= hy - r || norm([ax - (hx - r), ay - (hy - r)]) <= r);
x_wr = cx + W / 2 - wall;                           // right wall inner face
z_lid_ceil = Hb + lid_pocket;
// LTE flex under the lid, along y, as far right of the LILYGO as ant_gap to the two right lid screws allows
lte_sy = [min([for (s = screws) s[1]]), max([for (s = screws) s[1]])];
lte_dy = (lte_sy[1] - lte_sy[0] - 2 * 2.3 - lte_fpc[0]) / 2;   // free length past the flex at each end, screw box 2.3
lte_x1 = max([for (s = screws) s[0]]) - 2.3 - sqrt(max(0, pow(ant_gap, 2) - pow(lte_dy, 2)));
lte_xy = [lte_x1 - lte_fpc[1] / 2, (lte_sy[0] + lte_sy[1]) / 2];
lte_box = [[lte_x1 - lte_fpc[1], lte_xy[1] - lte_fpc[0] / 2, z_lid_ceil - lte_fpc[2]], [lte_x1, lte_xy[1] + lte_fpc[0] / 2, z_lid_ceil]];
// SMA knockout: top wall, between the LILYGO modem-end standoffs, its clearance circle under the rim chamfer
sma_x = (lily_a - lily_holes[2][0] + lily_a - lily_holes[3][0]) / 2;
sma_z = z_ch_of(Hb) - sma_cl_d / 2 - 1;
sma_box = [[sma_x - sma_cl_d / 2, cy + L / 2 - wall - sma_depth, sma_z - sma_cl_d / 2], [sma_x + sma_cl_d / 2, cy + L / 2, sma_z + sma_cl_d / 2]];
gps_box = [[gps_xy[0] - gps_patch[0] / 2, gps_xy[1] - gps_patch[1] / 2, z_lid_ceil - gps_patch[2]],
           [gps_xy[0] + gps_patch[0] / 2, gps_xy[1] + gps_patch[1] / 2, z_lid_ceil]];
car_box = [[0, 0, z_car_bot], [car_w, car_l, z_car_top]];
xh_box = [[68.58 - 2.5, 17.78 - 4.9, z_car_top], [68.58 + 3.25, 36.83 + 4.9, z_car_top + car_top_h]];
lily_box = [[lily_a - 30.846, lily_b - 110.541, z_top_bot], [lily_a + 2.047, lily_b, z_top_top]];
cell_box = [[bat_xy[0] - bat_holder[0] / 2, bat_xy[1] - bat_holder[1] / 2, z_top_bot - bat_holder[2]],
            [bat_xy[0] + bat_holder[0] / 2, bat_xy[1] + bat_holder[1] / 2, z_top_bot]];
metal = concat([car_box, xh_box, lily_box, cell_box], lte_antenna == "sma" ? [sma_box] : [],
  [for (s = screws) [[s[0] - 2.3, s[1] - 2.3, Hb + lid_h - cb_h - m3_len], [s[0] + 2.3, s[1] + 2.3, Hb + lid_h]]]);
gps_gap = min([for (b = metal) boxgap(gps_box, b)]);
lte_gap = min([for (b = metal) boxgap(lte_box, b)]);
lte_lily_h = lte_box[0][2] - z_top_top;          // flex over the LILYGO top
lte_over = max(0, lily_a + 2.047 - lte_box[0][0]);  // flex width over the LILYGO edge
lte_gnss = boxgap(lte_box, gps_box);
lte_usb = boxgap(lte_box, [[usb_c_xy[0] - 9.9, usb_c_xy[1] - 4.9, z_top_top], [usb_c_xy[0], usb_c_xy[1] + 4.8, z_top_top + 3.15]]);
fre_box = [[fre_a - fre_pcb_wl[0], fre_b - fre_pcb_wl[1], z_top_bot - fre_bot_h], [fre_a, fre_b - fre_pcb_wl[2], z_top_top + top_h]];
top_boxes = is_lily ? [lily_box, cell_box] : [fre_box];
if (gps_on) echo(str("CASE antennas: GNSS gap to metal ", gps_gap, " (LILYGO ", boxgap(gps_box, lily_box), ", carrier ", boxgap(gps_box, car_box),
  ", screws ", min([for (b = metal) if (b[1][2] > Hb) boxgap(gps_box, b)]), "), patch ", gps_box[0][2], " to ", gps_box[1][2], ", ",
  lte_on ? str("LTE flex on the lid x ", lte_box[0][0], " to ", lte_box[1][0], " y ", lte_box[0][1], " to ", lte_box[1][1], ", gap to metal ", lte_gap,
    " (lid screws ", min([for (b = metal) if (b[1][2] > Hb) boxgap(lte_box, b)]), ", LILYGO ", boxgap(lte_box, lily_box), "), ", lte_lily_h, " over the LILYGO top, ",
    lte_over, " wide over its edge, USB-C shell ", lte_usb, ", GNSS patch ", lte_gnss) : "LTE external through the SMA knockout",
  ", SMA knockout x ", sma_x, " z ", sma_z, " (", sma_z - floor_t, " above the floor), clearance to the boards and standoffs ", sma_board_gap,
  ", to the rim chamfer ", z_ch_of(Hb) - sma_z - sma_cl_d / 2, ", u.FL to the wall ", norm([sma_x - ipex_lte[0], cy + L / 2 - wall - ipex_lte[1]])));

assert(wall >= 2 && floor_t >= 2 && lid_t >= 2 && lip_t >= 2 && groove_wall >= 2, "walls under 2 mm");
assert(D >= need_in + need_out, str("no room for corner screws, raise Rg. D=", D));
// the carrier goes in from the top, so its corners must pass the ledge opening and the screw columns
car_off = [W / 2 - cx, min(L / 2 - cy, cy + L / 2 - car_l)];  // nearest carrier corner from its outer corner
arc_c = s_g + Rg;
car_corner_gap = Rl - norm([arc_c, arc_c] - car_off);
scr_off = [W / 2 - S0[0], L / 2 - S0[1]];
col_gap = norm(car_off - scr_off) - r_col;
assert(car_corner_gap >= 0.5, str("carrier corner hits the rim ledge, raise clear. gap=", car_corner_gap));
assert(col_gap >= 0.5 && scr_off[0] < car_off[0] && scr_off[1] < car_off[1], str("carrier corner hits a screw column. gap=", col_gap));
assert(lid_insert == "m3_small" || lid_ins_len == 4, "m3_large only comes in 4 mm, set lid_ins_len = 4");
assert(pcb_insert == "m3_small" || pcb_ins_len == 4, "m3_large only comes in 4 mm, set pcb_ins_len = 4");
assert(search([lid_ins_len], [4, 6, 8, 10])[0] != [] && search([pcb_ins_len], [4, 6, 8, 10])[0] != [], "insert lengths must be 4, 6, 8 or 10");
assert(Hb - ins_hole_l >= floor_t, str("lid column pocket breaks through the floor, max lid_ins_len ", Hb - floor_t - 6.5));
assert(z_car_bot - car_ins_h >= ins_test_floor, str("carrier standoff pocket leaves under ", ins_test_floor, " mm below it, max pcb_ins_len ", z_car_bot - ins_test_floor - 2));
assert(cb_h >= m3_head_h && clamp >= 2.4, "lid too thin under the screw head");
assert(screw_in >= ins_l && screw_in <= ins_hole_l - 0.5, str("screw length does not fit the insert hole: ", screw_in));
assert(Hb + lid_pocket - (z_top_top + hs_top) >= 1.5, "heatsinks touch the lid");
assert(!gps_on || gps_gap >= 7, str("GNSS patch too close to metal: ", gps_gap));
assert(!gps_on || boxgap(gps_box, car_box) >= ant_gap && boxgap(gps_box, cell_box) >= ant_gap, "GNSS patch near the carrier or the cell");
assert(!gps_on || min([for (b = metal) if (b[1][2] > Hb) boxgap(gps_box, b)]) >= ant_gap, "GNSS patch near a screw or insert");
assert(!gps_on || in_pocket(gps_box[0][0], gps_box[0][1], 2) && in_pocket(gps_box[1][0], gps_box[0][1], 2)
  && in_pocket(gps_box[0][0], gps_box[1][1], 2) && in_pocket(gps_box[1][0], gps_box[1][1], 2), "GNSS patch leaves the lid pocket (gasket tongue, screw columns)");
assert(!lte_on || lte_gap >= ant_gap, str("LTE flex too close to metal: ", lte_gap));
assert(!lte_on || min([for (x = [lte_box[0][0] - 1.8, lte_box[1][0] + 1.8], y = [lte_box[0][1] - 1.8, lte_box[1][1] + 1.8]) in_pocket(x, y, 0) ? 1 : 0]) == 1,
  "LTE flex locators leave the lid pocket");
assert(!lte_on || lte_box[0][2] - lte_seat_h - (z_top_top + lily_top_h) >= 1.5, "LTE locators on the LILYGO top parts");
// corner locators (L ribs, 1.8 out and 6 in from each flex corner) against the heatsinks below
lte_rib_hs = min(concat([99], [for (cxr = [[lte_box[0][0] - 1.8, lte_box[0][0] + 6], [lte_box[1][0] - 6, lte_box[1][0] + 1.8]],
  cyr = [[lte_box[0][1] - 1.8, lte_box[0][1] + 6], [lte_box[1][1] - 6, lte_box[1][1] + 1.8]], h = top_hs)
  let(p = [top_a - h[0][0], top_b - h[0][1]])
  if (gap1(cxr[0], cxr[1], p[0] - h[1][0] / 2, p[0] + h[1][0] / 2) == 0 && gap1(cyr[0], cyr[1], p[1] - h[1][1] / 2, p[1] + h[1][1] / 2) == 0)
    lte_box[0][2] - lte_seat_h - (z_top_top + h[2] + hs_h)]));
assert(!lte_on || lte_rib_hs >= 1.5, str("LTE locator over a heatsink: ", lte_rib_hs));
assert(!is_lily || sma_board_gap >= 1, str("SMA knockout on a board or standoff: ", sma_board_gap));
assert(!is_lily || sma_z - sma_cl_d / 2 >= floor_t + 1, "SMA knockout on the floor");
assert(tongue_h > 0, "gasket too tall for the groove");

// DC jack: nut and lugs keep-out inside, nut or flange round the hole outside. LILYGO: gland wall (-1) above the vent.
// Freenove: the end wall away from the PCB antenna, between the PG7 locknut and the USB-C plug path
y_gw = cy - L / 2 + wall;                          // gland wall inner face
z_gl = floor_t + gland_zc;                         // gland and vent centre
dcj_hole = [dcjack_d + dcjack_clear[0], dcjack_flat + dcjack_clear[1]];
dcj_side = is_lily ? -2 : (fre_ant_box2[0][1] + fre_ant_box2[1][1]) / 2 < cy ? 1 : -1;
fre_usb_xy = [for (u = fre_usb) [fre_a - u[1], fre_a - u[0]]];   // USB-C x ranges, case frame
fre_mouth_y = fre_b;                                              // both mouths face +y at the USB end of the board
fre_usb_zc = z_top_top + (fre_usb_z[0] + fre_usb_z[1]) / 2;
fre_plug_box = [[min([for (u = fre_usb_xy) (u[0] + u[1]) / 2]) - fre_usb_plug[0] / 2, fre_mouth_y, fre_usb_zc - fre_usb_plug[1] / 2],
                [max([for (u = fre_usb_xy) (u[0] + u[1]) / 2]) + fre_usb_plug[0] / 2, cy + L / 2 - wall, fre_usb_zc + fre_usb_plug[1] / 2]];
dcj_gl = [for (g = gl) if (g[1] == dcj_side) g];
dcj_x_hi = fre_plug_box[0][0] - 1 - dcj_r;         // 1 mm from the plug path
dcj_gl_l = len(dcj_gl) > 0 ? max([for (g = dcj_gl) if (g[0] < dcj_x_hi) g[0]]) : undef;
dcj_x_lo = len(dcj_gl) > 0 ? dcj_gl_l + sqrt(max(0, pow(dcj_r + gland_nut_ac / 2 + 1, 2) - pow(dcj_z - z_gl, 2)))   // 1 mm from the locknut
  : cx - W / 2 + r_v + dcj_r;                      // no gland on that wall: the wall corner
// glands on the jack wall: midway in the window. None: 2.5 mm off the USB-C plug path, where it sat beside the old glands
pwr_box = [[pwr_in_xy[0] - 3.25, pwr_in_xy[1] - 3.75, z_car_top], [pwr_in_xy[0] + 3.25, pwr_in_xy[1] + 3.75, z_car_top + car_top_h]];  // plug and wire bend
dcj_u_lily = max(port_y[1] + wall + dcj_r + 1, pwr_box[1][1] + dcj_r + 1);
// dcj_u: centre along its wall (y on the left wall), dcj_x: the same in the bottom wall frame of on_wall
dcj_u = is_lily ? dcj_u_lily : len(dcj_gl) > 0 ? (dcj_x_lo + dcj_x_hi) / 2 : dcj_x_hi - 1.5;
dcj_x = abs(dcj_side) == 2 ? cx + sign(dcj_side) * (dcj_u - cy) : dcj_u;
dcj_box = abs(dcj_side) == 2 ? let(x0 = dcj_side < 0 ? cx - W / 2 : cx + W / 2 - dcjack_depth)
    [[x0, dcj_u - dcj_r, dcj_z - dcj_r], [x0 + dcjack_depth, dcj_u + dcj_r, dcj_z + dcj_r]]
  : let(y0 = dcj_side < 0 ? cy - L / 2 : cy + L / 2 - dcjack_depth)
    [[dcj_u - dcj_r, y0, dcj_z - dcj_r], [dcj_u + dcj_r, y0 + dcjack_depth, dcj_z + dcj_r]];
car_parts_box = [[0, 0, z_car_top], [car_w, car_l, z_car_top + car_conn_h]];
so_boxes = concat([for (p = car_holes) [[p[0] - 5.6, p[1] - 5.6, floor_t], [p[0] + 5.6, p[1] + 5.6, z_car_bot]]],
  [for (p = top_pts) if (p[1] > car_l + 3) [[p[0] - 4.5, p[1] - 4.5, floor_t], [p[0] + 4.5, p[1] + 4.5, z_top_bot]]]);
dcj_vent_gap = dcj_side != -1 ? 99 : norm([dcj_x - vent_x, dcj_z - z_gl]) - dcj_r - vent_patch_d / 2;
dcj_gland_gap = len(dcj_gl) == 0 ? 99 : min([for (g = dcj_gl) norm([dcj_u - g[0], dcj_z - floor_t - g_zc(g)]) - dcj_r - gland_nut_ac / 2]);
sma_board_gap = min([for (b = concat([car_box, car_parts_box, xh_box, lily_box, cell_box], so_boxes)) boxgap(sma_box, b)]);
dcj_board_gap = min([for (b = concat([car_box, car_parts_box, xh_box, pwr_box], top_boxes, so_boxes)) boxgap(dcj_box, b)]);
dcj_plug_gap = is_lily ? 99 : boxgap(dcj_box, fre_plug_box);
dcj_floor_gap = dcj_z - dcj_r - floor_t;
dcj_pocket_r = dcj_r + 0.5;                        // nut spot face cut into the rim chamfer, teardrop top
dcj_pocket_top = dcj_z + dcj_pocket_r * sqrt(2);
dcj_rim_gap = z_ch_of(Hb) + ch_h - dcj_pocket_top;
dcj_web = dcj_side != -1 ? 99 : norm([dcj_x - vent_x, dcj_z - z_gl]) - dcj_hole[0] / 2 - vent_d / 2;
// wire from the lug end to the PWR_IN plug top, sampled in xy against the antenna and the plug path
dcj_lug = abs(dcj_side) == 2 ? [dcj_side < 0 ? dcj_box[1][0] : dcj_box[0][0], dcj_u, dcj_z] : [dcj_u, dcj_side < 0 ? dcj_box[1][1] : dcj_box[0][1], dcj_z];
pwr_top = [pwr_in_xy[0], pwr_in_xy[1], z_car_top + car_conn_h + plug_h];
dcj_wire = [for (i = [0:40]) dcj_lug + (pwr_top - dcj_lug) * i / 40];
function ptgap(p, b) = norm([gap1(p[0], p[0], b[0][0], b[1][0]), gap1(p[1], p[1], b[0][1], b[1][1])]);
dcj_wire_ant = is_lily ? 99 : min([for (p = dcj_wire) ptgap(p, fre_ant_box2)]);
dcj_wire_plug = is_lily ? 99 : min([for (p = dcj_wire) ptgap(p, fre_plug_box)]);
dcj_panel_gap = dcj_side != -2 ? 99 : dcj_u - dcjack_flange_d / 2 - (port_y[1] + wall);
if (dcj_on) echo(str("CASE dc jack ", dcj_side == -2 ? "left wall beside the port panel" : "end wall away from the antenna", ", centre ", abs(dcj_side) == 2 ? "y " : "x ", dcj_u, " z ", dcj_z, " (", dcj_z - floor_t, " above the floor), flange to the port panel ", dcj_panel_gap, ", hole ", dcj_hole[0], " flats ", dcj_hole[1],
  ", nut gap to vent patch ", dcj_vent_gap, ", to gland nuts ", dcj_gland_gap, ", to boards and standoffs ", dcj_board_gap,
  " (carrier parts ", boxgap(dcj_box, car_parts_box), ", PWR_IN plug ", boxgap(dcj_box, pwr_box), ", top board ", boxgap(dcj_box, top_boxes[0]), "), floor ", dcj_floor_gap,
  ", spot face top to the rim ledge ", dcj_rim_gap, ", hole web to vent ", dcj_web, ", thread past the nut ", dcjack_thread - wall - dcjack_nut[1],
  ", wire to PWR_IN ", norm(pwr_top - dcj_lug), " straight"));
if (dcj_on && !is_lily) echo(str("CASE freenove dc jack: x window ", dcj_x_lo, " to ", dcj_x_hi, ", nut to the USB-C plug path ", dcj_plug_gap,
  ", wire to PWR_IN ", norm(pwr_top - dcj_lug), " straight, its xy gap to the antenna ", dcj_wire_ant, " to the plug path ", dcj_wire_plug));
assert(!dcj_on || dcj_hole[1] < dcj_hole[0], "DC jack flats do not cut the hole");
assert(!dcj_on || dcj_vent_gap >= 1 - eps, str("DC jack nut on the vent patch: ", dcj_vent_gap));
assert(!dcj_on || dcj_gland_gap >= 1 - eps, str("DC jack nut on a gland nut: ", dcj_gland_gap));
assert(!dcj_on || dcj_board_gap >= 1 - eps, str("DC jack hits a board or standoff: ", dcj_board_gap));
assert(!dcj_on || (dcj_floor_gap >= 1 && dcj_rim_gap >= 1), "DC jack nut on the floor or its spot face in the rim ledge");
assert(!dcj_on || dcj_panel_gap >= 1, str("DC jack flange on the port panel: ", dcj_panel_gap));
assert(!dcj_on || dcj_side != -1 || norm([dcj_x - vent_x, dcj_z - z_gl]) - dcjack_flange_d / 2 - vent_d / 2 >= 2, "DC jack flange over the vent hole");
assert(!dcj_on || is_lily || dcj_x_hi >= dcj_x_lo, str("no room for the DC jack between the locknut and the USB-C plug path: ", dcj_x_lo, " to ", dcj_x_hi));
assert(!dcj_on || dcj_plug_gap >= 1 - eps, str("DC jack in the USB-C plug path: ", dcj_plug_gap));
assert(!dcj_on || is_lily || dcj_wire_ant >= ant_gap, str("DC jack wire near the Freenove antenna: ", dcj_wire_ant));
assert(!dcj_on || is_lily || dcj_wire_plug >= 1, str("DC jack wire across the USB-C plug path: ", dcj_wire_plug));
assert(!dcj_on || is_lily || norm(pwr_top - dcj_lug) <= 40, "DC jack wire to PWR_IN over 40 mm");

// adapter: jack flange and nut on the boss, boss and locknut on the gland wall
ad_slot = [dcjack_nut[0] + 0.6, dcjack_nut[1] + 0.6];   // nut spins in the slot, finger-tight onto the jack
ad_boss_h = ad_plate + ad_slot[1] + ad_back;
ad_thread_l = ad_gasket_t + wall + pg7_nut_h + 1.5;
ad_bore = dcj_hole[0] + 0.5;
ad_ac = ad_af / cos(30);
ad_g = gl[0];                                     // the first gland knockout, nearest its wall corner
ad_out_gap = min(ad_g[0] - ad_ac / 2 - ((abs(ad_g[1]) == 2 ? cy - L / 2 : cx - W / 2) + r_v), floor_t + g_zc(ad_g) - ad_ac / 2 - back_chamfer);
echo(str("CASE dc jack adapter: boss ", ad_af, " AF x ", ad_boss_h, ", thread PG7 ", ad_thread_d, " x ", ad_thread_l,
  ", jack flange ", dcjack_flange_d, " on the ", ad_af, " boss, nut slot ", ad_slot[0], " side walls ", (ad_af - ad_slot[0]) / 2,
  ", jack thread used ", ad_plate + dcjack_nut[1], " of ", dcjack_thread, ", boss to wall corner or back ", ad_out_gap));
assert(dcjack_flange_d <= ad_af - 2, "jack flange wider than the adapter boss");
assert((ad_af - ad_slot[0]) / 2 >= 2, "adapter nut slot walls under 2 mm");
assert(ad_plate + dcjack_nut[1] <= dcjack_thread - 0.5, "jack thread too short for the adapter plate and nut");
assert(ad_bore / 2 <= ad_thread_d / 2 - ad_depth - 1.2, "adapter tube wall under 1.2 mm at the thread root");
assert(ad_out_gap >= 1, "adapter boss over the wall corner or the back");
assert(!dcj_on || (abs(dcj_side) == 2 ? abs(dcj_u - cy) + dcj_r <= L / 2 - r_v : abs(dcj_u - cx) + dcj_r <= W / 2 - r_v), "DC jack nut in the wall corner radius");
assert(!dcj_on || dcjack_thread - wall >= dcjack_nut[1] + 1, "wall too thick for the DC jack thread and nut");
assert(g_w * g_h <= 0.9 * groove_w * g_squeezed, "groove over 90 % full when closed");

echo(str("CASE outer ", W, " x ", L, " x ", Hb + lid_h, " body ", Hb, " lid ", lid_h));
echo(str("CASE screws 4x M3 x ", m3_len, " from the top, ", screw_in, " below the seal face, insert hole ", ins_d, " x ", ins_hole_l,
  ", fits M3 x ", ceil(clamp + ins_l), " to M3 x ", floor(clamp + ins_hole_l - 0.5)));
echo(str("CASE ", variant, ": heatsink room ", Hb + lid_pocket - z_top_top, " above the top board, tallest heatsink top ", hs_top,
  ", height set by ", hb_boards >= max(hb_gland, hb_dcj, hb_gps) ? "boards and XH plugs" : hb_gps >= max(hb_gland, hb_dcj) ? "GNSS patch to the LILYGO edge"
    : hb_gland >= hb_dcj ? "PG7 locknut under the rim chamfer" : "DC jack spot face",
  " (boards ", hb_boards, ", locknut ", hb_gland, ", DC jack ", hb_dcj, ", GNSS ", hb_gps, ")"));
if (is_lily) echo(str("CASE carrier standoff ", car_so, " LILYGO standoff ", z_top_bot - floor_t, " USB-C centre z ", z_top_top + usb_z));
// glands: locknuts clear of the floor, the corner screw columns and each other, probe runs to J3A-D in order
gl_gaps = [for (i = [0:gland_n - 2], j = [i + 1:gland_n - 1]) norm([gl[i][0] - gl[j][0], gl[i][2] - gl[j][2]]) - gland_nut_ac];
gl_in = cx + sign(gland_side) * (W / 2 - wall - pg7_nut_h);   // locknut inner face (right or left wall)
gl_runs = [for (i = [0:gland_n - 1]) let(g = gl[i], c = xh_y[min(i, 3)])
  norm([gl_in - 68.58, g[0] - c, floor_t + g[2] - (z_car_top + car_conn_h + plug_h)])];
echo(str("CASE glands: ", gland_n, " x PG7 on wall ", gland_side, " at ", [for (g = gl) [g[0], g[2]]],
  " (along the wall, above the floor), window ", gl_lim, ", pitch ", gl_p, ", rows ", gl_dz > 0 ? str("staggered by ", gl_dz) : "one",
  ", locknut gaps ", min(gl_gaps), " (wanted ", gland_wrench, "), locknut inner face x ", gl_in, " to the XH plugs ", abs(gl_in - 68.58) - 3.25,
  ", probe runs to the plug tops ", gl_runs, ", spot faces on ", len([for (g = gl) if (floor_t + g[2] + gland_nut_ac / 2 > z_ch_of(Hb) + eps) 1]),
  " (top to the rim ledge ", z_ch_of(Hb) + ch_h - (floor_t + gl_zc_max + gl_pocket_r * sqrt(2)), ")"));
assert(abs(gland_side) == 2, "glands: only the left or right wall is checked");
assert(min(gl_gaps) >= gland_wrench - eps, str("locknuts too close: ", gl_gaps));
assert(min([for (g = gl) g[2]]) - gland_nut_ac / 2 >= 0.5 - eps, "locknut on the floor");
assert(gl_lim[1] >= gl_lim[0], "no room between the screw columns for the glands");
gl_rim = z_ch_of(Hb) + ch_h - (floor_t + gl_zc_max + gl_pocket_r * sqrt(2));
assert(gl_rim >= 1 - eps, str("locknut spot face in the rim ledge: ", gl_rim));

assert(z_jack + 8 + wall * 1.5 <= z_ch_of(Hb), "jack port panel in the rim chamfer");

// Freenove: antenna keep-out, lid rib over the USB-C shells, USB-C reach with the lid off
fre_ant = [[fre_ant_box2[0][0], fre_ant_box2[0][1], z_top_top], [fre_ant_box2[1][0], fre_ant_box2[1][1], z_top_top + fre_module[2]]];
fre_hold_x = [min([for (u = fre_usb_xy) u[0]]) + 1, max([for (u = fre_usb_xy) u[1]]) - 1];
fre_hold_y = [fre_b - fre_usb_y1 + 1.5, fre_b - fre_usb_y1 + 1.5 + fre_hold_t];
fre_hold_z = z_top_top + fre_usb_z[1] + fre_hold_gap;
fre_hold_box = [[fre_hold_x[0], fre_hold_y[0], fre_hold_z], [fre_hold_x[1], fre_hold_y[1], Hb + lid_pocket]];
fre_metal = concat([car_box, xh_box],
  [for (s = screws) [[s[0] - 2.3, s[1] - 2.3, Hb - ins_hole_l], [s[0] + 2.3, s[1] + 2.3, Hb + lid_h]]],
  dcj_on ? [dcj_box] : []);
fre_ant_metal = min([for (b = fre_metal) boxgap(fre_ant, b)]);
fre_usb_run = cy + L / 2 - wall - fre_mouth_y;
if (!is_lily) echo(str("CASE freenove: board z ", z_top_bot, " to ", z_top_top, " (", top_gap, " over the carrier), antenna y ", fre_ant[0][1], " to ", fre_ant[1][1],
  ", antenna to metal ", fre_ant_metal, " (screws and inserts ", min([for (b = fre_metal) if (b[1][2] > Hb - ins_hole_l - 1) boxgap(fre_ant, b)]),
  "), to the inner wall ", fre_ant[0][1] - (cy - L / 2 + wall), ", lid rib ", fre_hold ? str(fre_hold_box) : "off", ", USB-C centre z ", z_top_top + (fre_usb_z[0] + fre_usb_z[1]) / 2,
  " run from the mouth to the inner wall ", fre_usb_run, ", rim chamfer starts z ", z_ch_of(Hb)));
assert(is_lily || fre_ant_metal >= ant_gap, str("metal near the Freenove PCB antenna: ", fre_ant_metal));
assert(is_lily || !fre_hold || fre_hold_box[0][1] > fre_ant[1][1] + ant_gap, "lid rib over the Freenove antenna");
assert(is_lily || !fre_hold || fre_hold_box[0][2] - (z_top_top + fre_usb_z[1]) >= fre_hold_gap - eps, "lid rib on the USB-C shells");
assert(is_lily || Hb + lid_pocket - (z_top_top + top_h) >= 1.5, "Freenove top parts touch the lid");
echo(str("CASE gasket ring ", g_w, " x ", g_h, " squeezed to ", g_squeezed, " groove ", groove_w, " x ", groove_d,
  " play ", g_play, " per side, shore ", tpu_shore, " comp ", g_comp, " fill ", round(1000 * g_w * g_h / (groove_w * g_squeezed)) / 10, " %"));

// ---------- 2D ----------
module rr(i, r) {
  translate([cx, cy]) offset(r = max(r, 0.01))
    square([W - 2 * i - 2 * max(r, 0.01), L - 2 * i - 2 * max(r, 0.01)], center = true);
}
module cl2() rr(s_g, Rg);
module ring2(w) difference() { offset(r = w / 2) cl2(); offset(delta = -w / 2) cl2(); }
module ledge2() offset(delta = -(groove_w / 2 + groove_wall)) cl2();
module slab(z, h) translate([0, 0, z]) linear_extrude(h) children();
// round hole along y, flat-top teardrop so it prints sideways without support
module tear2(d) {
  r = d / 2;
  intersection() {
    union() { circle(d = d); rotate(45) square(r); }
    translate([-r, -r]) square([d, d]);
  }
}
module ears2() {
  for (sy = [-1, 1]) hull() {
    translate([cx, cy + sy * (L / 2 + ear_out - ear_w / 2)]) circle(d = ear_w);
    translate([cx - ear_w / 2, cy + sy * L / 2 - (sy > 0 ? 1 : 0)]) square([ear_w, 1]);
  }
}

// ---------- body ----------
module outer_solid(H) {
  hull() {
    slab(0, 0.01) rr(back_chamfer, r_v - back_chamfer);
    slab(back_chamfer, H - lip_h - back_chamfer) rr(0, r_v);
  }
  slab(H - lip_h - 0.01, lip_h + 0.01) rr(rim_in, r_v - rim_in);
  slab(0, ear_t) difference() {
    offset(r = -ear_fillet) offset(r = ear_fillet) union() { rr(0, r_v); ears2(); }
    rr(3, r_v - 3);
  }
  if (gland == "printed") for (g = gl) on_wall(g[1]) gland_boss(wall_u(g), g_zc(g));
}

module cavity(H) {
  zc = H - groove_d - 1.2 - ch_h;
  difference() {
    union() {
      slab(floor_t, zc - floor_t + 0.01) rr(wall, r_v - wall);
      hull() { slab(zc, 0.01) rr(wall, r_v - wall); slab(zc + ch_h, 0.01) ledge2(); }
      slab(zc + ch_h, H - zc - ch_h + 1) ledge2();
    }
    for (s = screws) translate([s[0], s[1], -1]) cylinder(r = r_col, h = H + 2);
  }
}

module standoff(p, z0, z1, od, hole, hole_h, ch = 0) {
  translate([p[0], p[1], 0]) difference() {
    union() {
      translate([0, 0, z0 - 0.01]) cylinder(d = od, h = z1 - z0 + 0.01);
      translate([0, 0, z0 - 0.01]) cylinder(d1 = od + 3, d2 = od, h = 1.5);
    }
    translate([0, 0, z1 - hole_h]) cylinder(d = hole, h = hole_h + 1);
    if (ch > 0) translate([0, 0, z1 - ch]) cylinder(d1 = hole, d2 = hole + 2 * ch + 0.02, h = ch + 0.01);
  }
}

boss_r = 11.5;
boss_len = 8;
module gland_boss(gx, zc = gland_zc) {
  gz = floor_t + zc;
  translate([gx, cy - L / 2 + 0.5, 0]) rotate([90, 0, 0]) linear_extrude(boss_len + 0.5)
    hull() { translate([0, gz]) circle(r = boss_r); translate([-boss_r * 0.7, 0]) square([boss_r * 1.4, 0.01]); }
}

// geometry drawn for the bottom wall, mirrored onto the top wall for side +1
// side -2/+2: the left/right wall, the bottom wall turned onto it. wall_u: a gland's x in the bottom wall frame
module on_wall(side) {
  if (side == -1) children();
  else if (side == 1) translate([0, cy, 0]) mirror([0, 1, 0]) translate([0, -cy, 0]) children();
  else translate([cx + sign(side) * (W - L) / 2, cy, 0]) rotate(sign(side) * 90) translate([-cx, -cy, 0]) children();
}
function wall_u(g) = abs(g[1]) == 1 ? g[0] : cx + sign(g[1]) * (g[0] - cy);
// hole through the bottom wall at (x, z), shut by a knockout membrane on the inside face. flat > 0: double-D, flats vertical
module hole2(d, flat) intersection() { tear2(d); square([flat > 0 ? flat : 2 * d, 2 * d], center = true); }
module wall_hole(x, z, d, extra = 0, flat = 0) {
  y_in = cy - L / 2 + wall;
  t = knockout ? ko_t : -1;
  translate([x, y_in - t, z]) rotate([90, 0, 0]) linear_extrude(wall - t + extra + 1) hole2(d, flat);
  if (knockout && ko_ring_w > 0)
    translate([x, y_in - ko_ring_t, z]) rotate([90, 0, 0]) linear_extrude(ko_t - ko_ring_t + 0.01)
      difference() {
        hole2(d, flat);
        hull() {                                    // centre keeps full thickness, its underside at 45 deg
          intersection() { circle(d = d - 2 * ko_ring_w); square([flat > 0 ? flat - 2 * ko_ring_w : 2 * d, 2 * d], center = true); }
          translate([0, -(d / 2 - ko_ring_w) * sqrt(2) - 0.1]) square(0.01, center = true);
        }
      }
}

module gland_holes() {
  d = gland == "pg7" ? 12.5 : gland == "m12" ? 12.2 : 12.5;
  for (g = gl) let(gz = floor_t + g_zc(g), gx = wall_u(g)) on_wall(g[1]) {
    wall_hole(gx, gz, d, boss_len + 1);
    if (gland == "printed") for (sx = [-1, 1])
      translate([gx + sx * 8.5, cy - L / 2 - boss_len + 8, gz]) rotate([90, 0, 0]) linear_extrude(9) tear2(2.5);
  }
}

// ---------- jack port: recessed panel in the left wall in front of J1A/J2A ----------
module port_bump() {
  top = z_jack + 8 + wall * 1.5;
  translate([0, port_y[1] + wall, 0]) rotate([90, 0, 0]) linear_extrude(port_y[1] - port_y[0] + 2 * wall)
    polygon([[x_w - 0.5, floor_t - 0.01], [x_pi, floor_t - 0.01], [x_pi, top], [x_w - 0.5, top + x_pi - x_w + 0.5]]);
}
module port_cut() {
  rp = 3;                                         // corner radius of the recess, vertical edges only
  minkowski() {
    translate([0, port_y[1] - rp, 0]) rotate([90, 0, 0]) linear_extrude(port_y[1] - port_y[0] - 2 * rp)
      polygon([[x_o - 1 - rp, z_jack - 8], [x_po - rp, z_jack - 8], [x_po - rp, z_jack + 8 - rp],
               [x_o - 1 - rp, z_jack + 8 - rp + x_po - x_o + 1]]);
    cylinder(r = rp, h = 0.01, $fn = 48);
  }
  for (jy = jack_y) {
    translate([x_po - 1, jy, z_jack]) rotate([90, 0, 90]) linear_extrude(wall + 2) tear2(jack_barrel_d + 0.6);
    translate([x_po - 1, jy, z_jack]) rotate([90, 0, 90]) linear_extrude(jack_front - x_po + 1) tear2(port_cb_d);
  }
}

// ---------- magnets ----------
mag_depth = mag_h + mag_sink;
ad_h = ear_t + ad_clr_z + ad_cap;                  // adapter is one flat block, back to cap top
ad_v1 = ear_out + ad_clr + ad_skirt;               // shoe and flange reach out from the wall
ad_us = [for (i = [0:ad_mag_n / 2 - 1]) ad_mag_u0 + i * (mag_hole + mag_web)];
ad_fl_u = ad_us[len(ad_us) - 1] + mag_hole / 2 + 2;
// ear outline beside the case in the adapter frame: u across, v out from the wall. Fillet arc, then the round end
ear_rc = ear_out - ear_w / 2;
ear_pts = [for (s = [-1, 1]) each concat(
  [for (a = [180:2:270]) [s * (ear_w / 2 + ear_fillet + ear_fillet * cos(a)), ear_fillet + ear_fillet * sin(a)]],
  [for (a = [0:2:90]) [s * ear_w / 2 * cos(a), ear_rc + ear_w / 2 * sin(a)]])];
ad_mag_gap = min([for (u = ad_us) min([for (p = ear_pts) norm([u, ad_mag_v] - p)])]) - mag_hole / 2 - ad_clr;
ad_mag_wall = min(ad_mag_v - mag_hole / 2 - ad_wall_gap, ad_v1 - ad_mag_v - mag_hole / 2);
ad_tip = ad_h - ad_screw[1];
echo(str("CASE ear magnet adapter: ", ad_mag_n, " pockets ", mag_hole, " x ", mag_depth, " at u ", ad_us, " v ", ad_mag_v,
  ", block ", 2 * ad_fl_u, " x ", ad_v1 - ad_wall_gap, " x ", ad_h, ", floor over the magnets ", ad_h - mag_depth,
  ", pocket to ear ", ad_mag_gap, ", to the flange edges ", ad_mag_wall, ", screw tip ", ad_tip, " above the back, ", ear_t - ad_tip, " in the ear"));
assert(ad_mag_n >= 2 && ad_mag_n % 2 == 0, "ad_mag_n must be even");
assert(mag_floor >= 1.2 && ad_h - mag_depth >= 1.2, "under 1.2 mm over a magnet");
assert(mag_sink >= 0 && mag_sink <= 0.1, "magnet face more than 0.1 below the back plane");
assert(ad_mag_gap >= 1.2, str("adapter pocket within 1.2 of the ear: ", ad_mag_gap));
assert(ad_mag_wall >= 1.2, str("adapter pocket within 1.2 of the flange edge: ", ad_mag_wall));
assert(ad_tip >= 0.5 && ear_t - ad_tip >= 2.5, str("adapter screw reaches the back plane or barely the ear: tip ", ad_tip));
assert(ad_screw[0] > ear_slot_d && ad_screw_hole > ad_screw[0], "adapter screw does not bite the slot or the cap hole is tight");
assert(ad_fl_u <= W / 2, "adapter flange wider than the case");

// case back pockets: pad over each pocket inside, clear of the wall, columns, standoffs, port panel and carrier pins
mag_pr = mag_hole / 2 + mag_pad_wall;
mag_top = mag_depth + mag_floor;
car_so_r = (car_ins_d + 4.2 + 3) / 2;
lily_so_r = (lily_pilot + 4.2 + 3) / 2;
function in_inner(x, y, m) = let(hx = W / 2 - wall - m, hy = L / 2 - wall - m, r = max(r_v - wall - m, 0),
  ax = abs(x - cx), ay = abs(y - cy)) ax <= hx && ay <= hy && (ax <= hx - r || ay <= hy - r || norm([ax - (hx - r), ay - (hy - r)]) <= r);
mag_gaps = [for (p = mag_xy) min(concat(
  [for (s = screws) norm(p - s) - r_col],
  [for (h = car_holes) norm(p - h) - car_so_r],
  [for (q = top_pts) if (q[1] > car_l + 3) norm(p - q) - lily_so_r])) - mag_pr];
mag_pair = len(mag_xy) < 2 ? 99 : min([for (i = [0:len(mag_xy) - 2], j = [i + 1:len(mag_xy) - 1]) norm(mag_xy[i] - mag_xy[j])]) - mag_hole;
echo(str("CASE back magnets: ", len(mag_xy), " pockets, pad ", 2 * mag_pr, " to z ", mag_top, ", gap to columns and standoffs ", min(mag_gaps),
  ", web between pockets ", mag_pair));
assert(mag_top <= z_car_bot - 3.3 - 0.5, "magnet pads reach the carrier pins");
assert(min(mag_gaps) >= 0.5, str("magnet pad on a screw column or standoff: ", mag_gaps));
assert(mag_pair >= mag_web, str("magnet pockets too close: ", mag_pair));
for (p = mag_xy) {
  assert(in_inner(p[0], p[1], mag_pr + 0.5), str("magnet pad in the wall at ", p));
  assert(!jack_port || p[0] - mag_pr - 0.5 >= x_pi || p[1] + mag_pr + 0.5 <= port_y[0] - wall || p[1] - mag_pr - 0.5 >= port_y[1] + wall,
    str("magnet pad under the jack port panel at ", p));
}

module ear_local2() mirror([0, 1]) translate([-cx, -(cy - L / 2)]) intersection() {
  offset(r = -ear_fillet) offset(r = ear_fillet) union() { rr(0, r_v); ears2(); }
  translate([cx - W, cy - L / 2 - 2 * ear_out]) square([2 * W, 2 * ear_out]);
}
// adapter frame: u = x - cx, v out from the wall, z up from the back plane. Every part sits at z >= 0
module ear_magnet_adapter() difference() {
  linear_extrude(ad_h) intersection() {
    union() {
      offset(r = ad_clr + ad_skirt) ear_local2();
      translate([0, (ad_wall_gap + ad_v1) / 2]) offset(r = 3) square([2 * ad_fl_u - 6, ad_v1 - ad_wall_gap - 6], center = true);
    }
    translate([-W, ad_wall_gap]) square([2 * W, ad_v1]);
  }
  translate([0, 0, -1]) linear_extrude(1 + ear_t + ad_clr_z) offset(r = ad_clr) ear_local2();
  translate([0, ear_out - 7, -1]) cylinder(d = ad_screw_hole, h = ad_h + 2);
  for (s = [-1, 1], u = ad_us) translate([s * u, ad_mag_v, -1]) cylinder(d = mag_hole, h = 1 + mag_depth);
}
module ear_magnets() for (s = [-1, 1], u = ad_us) translate([s * u, ad_mag_v, mag_sink]) cylinder(d = 10, h = mag_h);
// adapter frame to the case frame, side -1 the gland wall ear, +1 the other
module on_ear(side) on_wall(side) translate([cx, cy - L / 2, 0]) mirror([0, 1, 0]) children();

module body(H = Hb, coupon = false, mags = magnets) {
  difference() {
    union() {
      difference() { outer_solid(H); cavity(H); }
      if (jack_port) port_bump();
      for (p = top_pts) if (p[1] > car_l + 3) standoff(p, floor_t, min(z_top_bot, H - 2), lily_pilot + 4.2, lily_pilot, 8);
      for (p = car_holes) standoff(p, floor_t, min(z_car_bot, H - 2), car_ins_d + 4.2, car_ins_d, car_ins_h, ins_chamfer);
      if (mags && mag_top > floor_t) for (p = mag_xy) translate([p[0], p[1], floor_t - 0.01]) cylinder(r = mag_pr, h = mag_top - floor_t + 0.01);
    }
    if (mags) for (p = mag_xy) translate([p[0], p[1], -1]) cylinder(d = mag_hole, h = 1 + mag_depth);
    slab(H - groove_d, groove_d + 1) ring2(groove_w);
    for (s = screws) translate([s[0], s[1], H - ins_hole_l]) cylinder(d = ins_d, h = ins_hole_l + 1);
    for (s = screws) translate([s[0], s[1], H - ins_chamfer]) cylinder(d1 = ins_d, d2 = ins_d + 2 * ins_chamfer + 0.02, h = ins_chamfer + 0.01);
    gland_holes();
    for (g = gl) if (floor_t + g_zc(g) + gland_nut_ac / 2 > z_ch_of(H) + eps) on_wall(g[1])
      translate([wall_u(g), y_gw + ledge_in - wall, floor_t + g_zc(g)]) rotate([90, 0, 0]) linear_extrude(ledge_in - wall)
        hull() { circle(r = gl_pocket_r); translate([0, gl_pocket_r * sqrt(2)]) square(0.01, center = true); }
    if (jack_port) port_cut();
    if (vent) wall_hole(vent_x, floor_t + gland_zc, vent_d);
    if (dcj_on) {
      on_wall(dcj_side) {
        wall_hole(dcj_x, dcj_z, dcj_hole[0], 0, dcj_hole[1]);
        translate([dcj_x, y_gw + ledge_in - wall, dcj_z]) rotate([90, 0, 0]) linear_extrude(ledge_in - wall)
          hull() { circle(r = dcj_pocket_r); translate([0, dcj_pocket_r * sqrt(2)]) square(0.01, center = true); }
      }
    }
    if (is_lily && !coupon) on_wall(1) wall_hole(sma_x, sma_z, sma_d);
    for (sy = [-1, 1]) hull() for (k = [-1, 1])
      translate([cx, cy + sy * (L / 2 + ear_out - 7) + k * ear_slot_len / 2, -1])
        cylinder(d = ear_slot_d, h = ear_t + 2);
  }
}
function z_ch_of(H) = H - groove_d - 1.2 - ch_h;

// ---------- lid ----------
module lid_outer(H) {
  z0 = H - (lip_h - 0.5);
  zt = H + lid_h;
  hull() {
    slab(z0, zt - r_lid - z0) rr(0, r_v);
    for (a = [0:9:45]) slab(zt - r_lid + r_lid * sin(a), 0.01) rr(r_lid * (1 - cos(a)), r_v - r_lid * (1 - cos(a)));
    slab(zt - 0.01, 0.01) rr(r_lid * (2 - sqrt(2)) * 0.95, r_v - r_lid * (2 - sqrt(2)) * 0.95);  // 45 deg tail, a hair steeper
  }
}

module label2() translate([cx, cy]) offset(r = label_r) square([label_w - 2 * label_r, label_l - 2 * label_r], center = true);

// corner ribs that locate an antenna stuck to the lid pocket ceiling
module seat(sz, xy, H, h = 3) {
  for (sx = [-1, 1], sy = [-1, 1]) translate([xy[0] + sx * (sz[0] / 2 + 1.2), xy[1] + sy * (sz[1] / 2 + 1.2), H + lid_pocket - h])
    linear_extrude(h + 0.01) union() {
      translate([-0.6 - (sx > 0 ? 5.4 : 0), -0.6]) square([6, 1.2]);
      translate([-0.6, -0.6 - (sy > 0 ? 5.4 : 0)]) square([1.2, 6]);
    }
}

module lid(H = Hb, recess = true) {
  zt = H + lid_h;
  difference() {
    lid_outer(H);
    slab(H - lip_h - 1, lip_h + 1) rr(lip_t, r_v - lip_t);
    slab(H - 1, lid_pocket + 1) offset(delta = -0.5) ledge2();
    for (s = screws) translate([s[0], s[1], 0]) screw_hole_lid(H);
    if (recess && label_depth > 0) slab(zt - label_depth, 1) label2();
  }
  slab(H - tongue_h, tongue_h + 0.01) ring2(tongue_w);
  if (gps_on) seat(gps_patch, gps_xy, H, min(3, gps_patch[2]));
  if (lte_on) seat([lte_fpc[1], lte_fpc[0]], lte_xy, H, lte_seat_h);
  if (!is_lily && fre_hold) fre_hold_rib(H);
}

// Freenove: rib from the lid ceiling down to fre_hold_gap over both USB-C shells. Prints upright with the lid
module fre_hold_rib(H) {
  z0 = H - Hb + fre_hold_box[0][2];
  translate([fre_hold_x[0], fre_hold_y[0], z0]) cube([fre_hold_x[1] - fre_hold_x[0], fre_hold_t, H + lid_pocket - z0 + 0.01]);
}

// label for the recess, in the flipped lid frame: first layer on the lid's top plane (z 0), same size as the recess
module label_insert(H = Hb) flip(H) translate([0, 0, H + lid_h - label_depth]) linear_extrude(label_depth) label2();

// clearance hole and head counterbore. Printed face down, the counterbore roof is two bridge
// layers: a slot across the counterbore, then a square across the slot, then the round hole
module screw_hole_lid(H) {
  zt = H + lid_h;
  translate([0, 0, H - 1]) cylinder(d = m3_clear, h = lid_h + 2);
  translate([0, 0, zt - cb_h]) cylinder(d = cb_d, h = cb_h + 1);
  translate([0, 0, zt - cb_h - layer_h]) linear_extrude(layer_h + 0.01) intersection() {
    square([cb_d, m3_clear], center = true); circle(d = cb_d);
  }
  translate([0, 0, zt - cb_h - 2 * layer_h]) linear_extrude(layer_h + 0.01) square(m3_clear, center = true);
}

module gasket() linear_extrude(g_h) ring2(g_w);

// ---------- small parts ----------
module gland_grommet() difference() {
  cylinder(d = 12.3, h = wall + boss_len + 1);
  translate([0, 0, -1]) cylinder(d = cable_d - 0.3, h = 20);
}
module gland_cap() difference() {
  hull() for (sx = [-1, 1]) translate([sx * 8.5, 0]) cylinder(r = 4.5, h = 3);
  translate([0, 0, -1]) cylinder(d = cable_d + 0.6, h = 5);
  for (sx = [-1, 1]) translate([sx * 8.5, 0, -1]) cylinder(d = 3.4, h = 5);
}
// TPU boot: pressed into the jack seat, grips the plug body
module jack_boot() difference() {
  union() {
    cylinder(d = port_cb_d + 0.3, h = jack_front - x_po);
    translate([0, 0, jack_front - x_po]) cylinder(d1 = port_cb_d + 0.3, d2 = plug_d + 2.4, h = 6);
  }
  translate([0, 0, -1]) cylinder(d = plug_d - 0.4, h = 20);
}
// TPU cap for an unused jack
module jack_cap() {
  cylinder(d = port_cb_d + 3, h = 1.6);
  cylinder(d = port_cb_d + 0.3, h = 1.6 + jack_front - x_po);
}

// ---------- DC jack adapter for a PG7 knockout ----------
function th_prof(t, f, c) = t < c ? 0 : t < c + f ? (t - c) / f : t < 2 * c + f ? 1 : 1 - (t - 2 * c - f) / f;
// male thread on a deformed cylinder, single start, root radius d/2 - depth
module thread(d, p, h, depth, na = 72) {
  f = depth * 1.1 / p;                            // flank share of the pitch, 1.1 x depth wide: 42 deg
  c = (1 - 2 * f) / 2;                            // root and crest flats
  nz = ceil(h / (p / 16));
  pts = concat([for (iz = [0:nz], ia = [0:na - 1]) let(z = h * iz / nz, a = 360 * ia / na,
      t = ((z / p - a / 360) % 1 + 1) % 1, r = d / 2 - depth + depth * th_prof(t, f, c)) [r * cos(a), r * sin(a), z]],
    [[0, 0, 0], [0, 0, h]]);
  B = (nz + 1) * na;
  function q(iz, ia) = iz * na + (ia % na);
  polyhedron(pts, concat(
    [for (iz = [0:nz - 1], ia = [0:na - 1], k = [0, 1]) k == 0 ? [q(iz, ia), q(iz + 1, ia), q(iz + 1, ia + 1)] : [q(iz, ia), q(iz + 1, ia + 1), q(iz, ia + 1)]],
    [for (ia = [0:na - 1]) [B, q(0, ia), q(0, ia + 1)]],
    [for (ia = [0:na - 1]) [B + 1, q(nz, ia + 1), q(nz, ia)]]));
}
module dcjack2() intersection() { circle(d = dcj_hole[0]); square([dcj_hole[1], 2 * dcj_hole[0]], center = true); }
// print frame: boss face on the bed, thread up. The jack goes in from the face, its nut in the slot
module dcjack_adapter() difference() {
  union() {
    cylinder(d = ad_ac, h = ad_boss_h, $fn = 6);
    translate([0, 0, ad_boss_h - 0.01]) intersection() {
      thread(ad_thread_d, ad_pitch, ad_thread_l, ad_depth);
      cylinder(h = ad_thread_l, r1 = ad_thread_d / 2 - ad_depth + ad_thread_l, r2 = ad_thread_d / 2 - ad_depth);
    }
  }
  translate([0, 0, -1]) linear_extrude(ad_plate + 2) dcjack2();
  translate([-ad_slot[0] / 2, -ad_slot[0] / 2, ad_plate]) cube([ad_ac, ad_slot[0], ad_slot[1]]);
  // slot roof as two bridge layers: a strip, then a square, then the round bore
  translate([-ad_slot[0] / 2, -ad_bore / 2, ad_plate + ad_slot[1] - 0.01]) cube([ad_ac, ad_bore, layer_h + 0.01]);
  translate([-ad_bore / 2, -ad_bore / 2, ad_plate + ad_slot[1] + layer_h - 0.01]) cube([ad_bore, ad_bore, layer_h + 0.01]);
  translate([0, 0, ad_plate + ad_slot[1] + 2 * layer_h - 0.02]) cylinder(d = ad_bore, h = ad_boss_h + ad_thread_l);
}
module dcjack_adapter_gasket() difference() {
  cylinder(d = ad_af, h = ad_gasket_t);
  translate([0, 0, -1]) cylinder(d = ad_thread_d + 0.4, h = ad_gasket_t + 2);
}
// adapter with the jack, nut, gasket and locknut, exploded along z, print frame
module dcjack_adapter_view(e = 12) {
  color(c_body) dcjack_adapter();
  color(c_tpu) translate([0, 0, ad_boss_h + e]) dcjack_adapter_gasket();
  color(c_steel) {
    translate([0, 0, -e - 2]) cylinder(d = dcjack_flange_d, h = 2);
    translate([0, 0, -e]) intersection() { cylinder(d = dcjack_d, h = dcjack_thread); cube([dcjack_flat, 2 * dcjack_d, 3 * dcjack_thread], center = true); }
    translate([ad_ac / 2 + 10, 0, ad_plate + 0.3]) cylinder(d = dcjack_nut[0], h = dcjack_nut[1], $fn = 6);
    translate([0, 0, ad_boss_h + ad_gasket_t + wall + 2 * e]) difference() {
      cylinder(d = gland_nut_ac, h = pg7_nut_h, $fn = 6); translate([0, 0, -1]) cylinder(d = ad_thread_d - 2 * ad_depth, h = pg7_nut_h + 2);
    }
  }
  color("#141414") translate([0, 0, -e + dcjack_thread]) cylinder(d = dcjack_d - 1, h = dcjack_depth - dcjack_thread);
}

// ---------- reference boards (preview only) ----------
module boards() {
  color("#24593d") translate([0, 0, z_car_bot]) difference() {
    cube([car_w, car_l, car_pcb]);
    for (p = car_holes) translate([p[0], p[1], -1]) cylinder(d = car_hole_d, h = 4);
  }
  if (is_lily) {
    color("#141414") for (x = [29.46, 59.95]) translate([x - 1.27, 12.95 - 1.27, z_car_top]) cube([2.54, 40.64, car_hdr_h]);
    color("#b8b8b8") for (x = [29.46, 59.95]) translate([x - 0.4, 12.95 - 0.4, z_car_top + car_hdr_h]) cube([0.8, 38.9, stack_gap - car_hdr_h]);
  } else {                                        // U1_B1/U1_B2 1 x 20 sockets, the Freenove header plastic on top
    color("#141414") for (x = [32.004, 57.404]) translate([x - 1.27, 2.794 - 1.27, z_car_top]) cube([2.54, 50.8, car_hdr_h]);
    color("#2a2a2a") for (r = fre_rows) translate([fre_a - r - 1.27, fre_b - fre_pin1_y - 19 * 2.54 - 1.27, z_car_top + car_hdr_h]) cube([2.54, 50.8, fre_spacer]);
  }
  color("#f2f2f2") for (y = [17.78, 24.13, 30.48, 36.83]) translate([68.58 - 2.5, y - 4.9, z_car_top]) cube([5.75, 9.8, car_conn_h]);
  color("#141414") for (y = jack_y) {
    translate([jack_front + 1.5, y - 6, z_car_top]) cube([12.7, 12, 5.5]);
    translate([jack_front, y, z_jack]) rotate([0, 90, 0]) cylinder(d = jack_barrel_d, h = 1.6);
  }
  if (is_lily) lilygo3(); else freenove3();
}
module lilygo3() {
  color("#1b1b1f") translate([0, 0, z_top_bot]) linear_extrude(lily_pcb)
    translate([lily_a, lily_b]) rotate(180) polygon([[0, 0], [28.814, 0], [30.846, 2.032], [30.846, 108.522],
      [28.828, 110.541], [23.9, 110.541], [23.9, 104.496], [4.9, 104.496], [4.9, 110.541], [-0.009, 110.541],
      [-2.047, 108.503], [-2.047, 2.032], [-0.015, 0]]);
  color("#5a5a5a") translate([bat_xy[0] - bat_holder[0] / 2, bat_xy[1] - bat_holder[1] / 2, z_top_bot - bat_holder[2]])
    cube(bat_holder);
  color("#e8c21a") translate([bat_xy[0], bat_xy[1], z_top_bot - bat_h + cell[0] / 2]) rotate([90, 0, 0]) cylinder(d = cell[0], h = cell[1], center = true);
  color("#c8c8c8") translate([usb_c_xy[0] - 9.9, usb_c_xy[1] - 4.9, z_top_top]) cube([9.9, 9.7, 3.15]);
  color("#bfbfbf") translate([lily_a - 14.4 - 9, lily_b - 97.7 - 12.75, z_top_top]) cube([18, 25.5, 3.1]);
}
// Freenove FNK0085 from the vendor model boxes, case frame. Camera left off
module freenove3() {
  module bx(p0, p1, z0, h) { q0 = fre_pt(p1); q1 = fre_pt(p0); translate([q0[0], q0[1], z0]) cube([q1[0] - q0[0], q1[1] - q0[1], h]); }
  color("#1b1b1f") bx([0, fre_pcb_wl[2]], [fre_pcb_wl[0], fre_pcb_wl[1]], z_top_bot, fre_pcb);
  color("#2b2b2b") bx(fre_module[0], [fre_module[1][0], fre_module[1][1]], z_top_top, 0.73);
  color("#bfbfbf") bx([6.05, 32.75], [21.85, fre_ant_y0], z_top_top, fre_module[2]);
  color("#c8c8c8") for (u = fre_usb) bx([u[0], 0.01], [u[1], fre_usb_y1], z_top_top + fre_usb_z[0], fre_usb_z[1] - fre_usb_z[0]);
  color("#e8e8e8") for (b = fre_buttons) bx(b, b + [3, 4], z_top_top, 1.36);
  color("#3a3a3a") bx([5.17, 20.2], [22.77, 25.5], z_top_top, 2.0);
}
module cable(pts, d = 1.1) for (i = [0:len(pts) - 2]) hull() for (k = [i, i + 1]) translate(pts[k]) sphere(d = d, $fn = 12);
module gps_antenna() if (gps_on) {
  color("#c9874a") translate(gps_box[0]) cube(gps_box[1] - gps_box[0]);
  color("#d9d9d9") cable([[gps_box[1][0], gps_xy[1] + 4, z_lid_ceil - 1], [gps_box[1][0] + 2, 108, z_top_top + 6],
    [ipex_gnss[0], ipex_gnss[1], z_top_top + 2]]);
}
module lte_antenna_lid() if (lte_on) {
  color("#2fb8a8") translate(lte_box[0]) cube(lte_box[1] - lte_box[0]);
  color("#d9d9d9") cable([[lte_box[0][0] + 3, lte_box[1][1] - 2, z_lid_ceil - 1], [lte_box[0][0] - 2, 118, z_top_top + 6],
    [ipex_lte[0], ipex_lte[1], z_top_top + 2]]);
}

// ---------- coupon ----------
module coupon_box() translate([cx - W / 2 - 20, cy - L / 2 - 20, -1]) cube([W / 2 - cx + 26 + 20, 36 + 20, 200]);

// insert_test: straight holes along z, open upward like the case corners, label under each hole. Print as is
function d1(d) = let(t = round(d * 100)) t % 10 == 0 ? str(floor(t / 100), ".", floor(t / 10) % 10) : str(floor(t / 100), ".", floor(t / 10) % 10, t % 10);
it_r = max(concat(ins_test_d, ins_test_fine)) / 2 + ins_chamfer;          // widest mouth
it_n = len(ins_test_d);
it_w = it_n * ins_test_pitch;
it_y = [-(it_r + 1 + ins_test_txt + 1.6), it_r + ins_wall];
it_h = ins_hole_l + ins_test_floor;
assert(ins_test_pitch - 2 * it_r >= ins_wall && ins_test_pitch / 2 - it_r >= ins_wall, "insert_test walls under ins_wall");
module insert_test(ds = ins_test_d) difference() {
  translate([0, it_y[0], 0]) linear_extrude(it_h) offset(r = 1.5) offset(delta = -1.5) square([it_w, it_y[1] - it_y[0]]);
  for (i = [0:len(ds) - 1]) let(d = ds[i], x = (i + 0.5) * ins_test_pitch) {
    translate([x, 0, it_h - ins_hole_l]) cylinder(d = d, h = ins_hole_l + 1);
    translate([x, 0, it_h - ins_chamfer]) cylinder(d1 = d, d2 = d + 2 * ins_chamfer + 0.02, h = ins_chamfer + 0.01);
    translate([x, -(it_r + 1 + ins_test_txt / 2), it_h - ins_test_deboss]) linear_extrude(ins_test_deboss + 1)
      text(d1(d), size = ins_test_txt, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
  }
}
echo(str("CASE insert_test: ", it_w, " x ", it_y[1] - it_y[0], " x ", it_h, ", holes ", ins_test_d, " x ", ins_hole_l, " chamfer ", ins_chamfer,
  ", wall between holes ", ins_test_pitch - 2 * it_r, " at the mouth, ", ins_test_pitch - max(ins_test_d), " below it"));

// ---------- output ----------
c_body = "#3b4148";
c_lid = "#5b86b0";
c_tpu = "#e2702b";
c_brass = "#c9a227";
c_steel = "#8a9199";
c_hs = "#9fb8c9";

// hardware for the previews: M3 x 5.7 inserts, DIN 912 screws, heatsinks
module inserts(z) color(c_brass) for (s = screws) translate([s[0], s[1], z]) difference() {
  cylinder(d = ins_od, h = ins_l); translate([0, 0, -1]) cylinder(d = 3, h = ins_l + 2);
}
module screws3(z) color(c_steel) for (s = screws) translate([s[0], s[1], z]) {
  translate([0, 0, -m3_len]) cylinder(d = 2.9, h = m3_len);
  difference() { cylinder(d = m3_head_d, h = m3_head_h); translate([0, 0, 1]) cylinder(d = 2.5, h = 3, $fn = 6); }
}
module heatsinks3() color(c_hs) for (h = top_hs) {
  p = [top_a - h[0][0], top_b - h[0][1]];
  translate([p[0] - h[1][0] / 2, p[1] - h[1][1] / 2, z_top_top + h[2]]) {
    cube([h[1][0], h[1][1], 1.5]);
    for (i = [0:3:h[1][0] - 1]) translate([i, 0, 1.5]) cube([1, h[1][1], hs_h - 1.5]);
  }
}

// Orca modifier volumes in the body frame: wall = 2.5 round an insert hole
mod_ins_d = ins_d + 2 * 2.5;
mod_car_d = car_ins_d + 2 * 2.5;
module modifier_inserts() for (s = screws) translate([s[0], s[1], 0]) cylinder(d = mod_ins_d, h = Hb);
module modifier_carrier_mounts() for (p = car_holes) translate([p[0], p[1], floor_t]) cylinder(d = mod_car_d, h = z_car_bot - floor_t);

// DC jack, vent patch and gland nuts for the gland wall previews, sizes from the parameters
module along_y(x, y, z) translate([x, y, z]) rotate([-90, 0, 0]) children();
module dcjack_hw() if (dcj_on) on_wall(dcj_side) along_y(dcj_x, y_gw - wall, dcj_z) {
  color(c_steel) {
    translate([0, 0, -2]) cylinder(d = dcjack_nut[0], h = 2);
    intersection() { cylinder(d = dcjack_d, h = dcjack_thread); cube([dcjack_flat, 2 * dcjack_d, 3 * dcjack_thread], center = true); }
    translate([0, 0, wall]) cylinder(d = dcjack_nut[0], h = dcjack_nut[1], $fn = 6);
  }
  color("#141414") translate([0, 0, dcjack_thread]) cylinder(d = dcjack_d - 1, h = dcjack_depth - dcjack_thread);
}
module gland_wall_hw() {
  if (dcj_side == gland_side) dcjack_hw();
  if (vent) color("#f2f2f2") along_y(vent_x, y_gw, z_gl) cylinder(d = vent_patch_d, h = 0.3);
  color(c_steel) for (g = gl) on_wall(g[1]) {
    along_y(wall_u(g), y_gw, floor_t + g_zc(g)) cylinder(d = gland_nut_ac, h = 5, $fn = 6);
    along_y(wall_u(g), y_gw - wall - 5, floor_t + g_zc(g)) cylinder(d = gland_nut_ac, h = 5, $fn = 6);
  }
}
// keep-outs for the jack previews: PCB antenna (red), USB-C plug path (blue), the jack wire to PWR_IN
module beyond() difference() { children(); translate([dcj_x - 300, -100, -10]) cube([300, 400, 300]); }
module dcjack_keepouts() {
  if (!is_lily) {
    color("#e03131", 0.45) translate(fre_ant[0]) cube(fre_ant[1] - fre_ant[0]);
    color("#1c7ed6", 0.35) translate(fre_plug_box[0]) cube(fre_plug_box[1] - fre_plug_box[0]);
  }
  if (dcj_on && !is_lily) color("#c92a2a") cable([dcj_lug, [dcj_lug[0] - 4, dcj_lug[1] - 3 * dcj_side, dcj_z - 2], pwr_top], 1.6);
}
module keep_y(y1) intersection() { children(); translate([-100, -100, -50]) cube([400, 100 + y1, 300]); }
gl_view_cut = is_lily ? 18 : 25;
module keep_x(x0, side) intersection() { children(); translate([side > 0 ? x0 : x0 - 400, -100, -50]) cube([400, 400, 300]); }

module cut(c) color(c) difference() { children(); translate([cx + 10, -50, -1]) cube([200, 300, 200]); }
module flip(H) translate([0, 0, H + lid_h]) rotate([180, 0, 0]) children();

if (part == "assembly") {
  color(c_body) body();
  color(c_lid) lid();
  screws3(Hb + lid_h - cb_h);
  color(c_tpu) translate([0, 0, Hb - groove_d]) gasket();
  if (jack_port) color(c_tpu) {
    translate([x_po - 1.6, jack_y[0], z_jack]) rotate([0, 90, 0]) jack_cap();
    translate([jack_front, jack_y[1], z_jack]) rotate([0, -90, 0]) jack_boot();
  }
} else if (part == "exploded") {
  color(c_body) body();
  boards();
  heatsinks3();
  inserts(Hb - ins_l + explode * 0.3);
  color(c_tpu) translate([0, 0, Hb - groove_d + explode * 0.55]) gasket();
  translate([0, 0, explode * 1.0]) { color(c_lid) lid(); gps_antenna(); lte_antenna_lid(); }
  screws3(Hb + lid_h - cb_h + explode * 1.45);
  if (jack_port) color(c_tpu) translate([jack_front - explode * 0.35, jack_y[1], z_jack]) rotate([0, -90, 0]) jack_boot();
} else if (part == "inside") {   // body open with the LTE flex on the wall, lid turned over beside it with the GNSS patch
  color(c_body) body();
  boards();
  heatsinks3();
  translate([0, -L - 12, 0]) {
    color(c_lid) translate([0, 2 * cy, Hb + lid_h]) rotate([180, 0, 0]) lid();
    translate([0, 2 * cy, Hb + lid_h]) rotate([180, 0, 0]) { gps_antenna(); lte_antenna_lid(); }
  }
} else if (part == "gland_wall") {   // gland wall from outside: vent and DC jack knockouts, gland nuts
  color(c_body) body();
  color(c_steel, 0.45) for (g = gl) on_wall(g[1]) along_y(wall_u(g), y_gw - wall - 5, floor_t + g_zc(g)) cylinder(d = gland_nut_ac, h = 5, $fn = 6);
} else if (part == "gland_wall_in") {   // gland wall from inside, cut past the top board: locknuts, spot faces, XH plugs, carrier
  color(c_body) keep_x(gl_in - sign(gland_side) * gl_view_cut, gland_side) body();
  keep_x(gl_in - sign(gland_side) * gl_view_cut, gland_side) boards();
  gland_wall_hw();
} else if (part == "sma_wall") {   // top wall from outside: SMA knockout, bulkhead nut and washer clearance ghosted
  color(c_body) body();
  color(c_steel, 0.45) on_wall(1) along_y(sma_x, y_gw - wall - 2, sma_z) cylinder(d = sma_cl_d, h = 2);
} else if (part == "port_wall") {   // left wall from outside: jack port panel, boot and cap, DC jack
  color(c_body) body();
  if (jack_port) color(c_tpu) {
    translate([x_po - 1.6, jack_y[0], z_jack]) rotate([0, 90, 0]) jack_cap();
    translate([jack_front, jack_y[1], z_jack]) rotate([0, -90, 0]) jack_boot();
  }
  dcjack_hw();
} else if (part == "port_wall_in") {   // left wall from inside, cut 25 mm in: jack bodies, DC jack nut, PWR_IN, carrier
  color(c_body) keep_x(x_w + 25, -2) body();
  keep_x(x_w + 25, -2) boards();
  dcjack_hw();
  color("#f2f2f2") translate(pwr_box[0]) cube([pwr_box[1][0] - pwr_box[0][0], pwr_box[1][1] - pwr_box[0][1], car_conn_h]);
} else if (part == "section_board") {   // case and boards cut at x = cx + 10: stack, lid rib, USB-C
  cut(c_body) body();
  cut(c_lid) lid();
  cut(c_tpu) translate([0, 0, Hb - groove_d]) gasket();
  difference() { boards(); translate([cx + 10, -50, -1]) cube([200, 300, 200]); }
} else if (part == "section") {   // case cut at x = cx + 10, groove and gasket in place
  cut(c_body) body();
  cut(c_lid) lid();
  cut(c_tpu) translate([0, 0, Hb - groove_d]) gasket();
} else if (part == "body") body();
else if (part == "body_magnets") body(Hb, false, true);
else if (part == "ear_magnet_adapter") translate([0, 0, ad_h]) rotate([180, 0, 0]) ear_magnet_adapter();
else if (part == "ear_adapter_back") {   // gland wall end from the back: adapter on the ear, magnets in, all flush with the case back
  color(c_body) keep_y(cy - L / 2 + 30) body();
  color(c_lid) on_ear(-1) ear_magnet_adapter();
  color(c_steel) on_ear(-1) ear_magnets();
  color(c_steel) translate([cx, cy - L / 2 - ear_out + 7, ad_h]) cylinder(d = 9.5, h = 3.5);
}
else if (part == "ear_adapter_side") {   // whole case from the side on a steel sheet, both adapters on
  color(c_body) body();
  color(c_lid) lid();
  for (sd = [-1, 1]) { color(c_lid) on_ear(sd) ear_magnet_adapter(); color(c_steel) on_ear(sd) ear_magnets(); }
  color("#b8bec6") translate([-30, -30, -1]) cube([W + 30, L + 60, 1]);
}
else if (part == "body_magnets_back") {   // next version: pockets in the case back, magnets in half of them
  color(c_body) body(Hb, false, true);
  color(c_steel) for (i = [0:2:len(mag_xy) - 1]) translate([mag_xy[i][0], mag_xy[i][1], mag_sink]) cylinder(d = 10, h = mag_h);
}
else if (part == "lid_with_label_recess") flip(Hb) lid(Hb, true);
else if (part == "lid_solid") flip(Hb) lid(Hb, false);
else if (part == "label_insert") label_insert();
else if (part == "modifier_inserts") modifier_inserts();
else if (part == "modifier_carrier_mounts") modifier_carrier_mounts();
else if (part == "modifiers") {
  color("#c8c8c8") intersection() { body(); translate([-50, -50, -1]) cube([300, 300, 15]); }
  color("#e8590c") modifier_inserts();
  color("#1971c2") modifier_carrier_mounts();
}
else if (part == "gasket") gasket();
else if (part == "dcjack_adapter") dcjack_adapter();
else if (part == "dcjack_adapter_gasket") dcjack_adapter_gasket();
else if (part == "dcjack_adapter_view") dcjack_adapter_view();
else if (part == "gland_grommet") gland_grommet();
else if (part == "gland_cap") gland_cap();
else if (part == "jack_boot") jack_boot();
else if (part == "jack_cap") jack_cap();
else if (part == "coupon_body") color(c_body) intersection() { body(coupon_h, true); coupon_box(); }
else if (part == "coupon_lid") flip(coupon_h) intersection() { lid(coupon_h); coupon_box(); }
else if (part == "coupon_gasket") intersection() { gasket(); coupon_box(); }
else if (part == "insert_test") color(c_body) insert_test();
else if (part == "insert_test_fine") color(c_body) insert_test(ins_test_fine);
else if (part == "insert_test_fine_small") color(c_body) insert_test(ins_test_fine_small);
else if (part == "dcjack_section") {   // cut through the DC jack at x = dcj_x, the part beyond it: jack, boards, antenna keep-out
  color(c_body) beyond() body();
  beyond() boards();
  beyond() dcjack_hw();
  dcjack_keepouts();
} else if (part == "dcjack_inside") {   // body open from above: DC jack, wire to PWR_IN, antenna and USB-C plug keep-outs
  color(c_body) body();
  boards();
  dcjack_hw();
  dcjack_keepouts();
}
