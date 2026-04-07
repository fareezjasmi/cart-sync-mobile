"""
Cart Sync - App Icon Generator
Generates 1024x1024 app icon and 1024x500 Play Store feature graphic.
"""

from PIL import Image, ImageDraw
import math
import os

SIZE = 1024
WHITE = (255, 255, 255)
SEMI_WHITE = (255, 255, 255, 180)


def lerp(a, b, t):
    return a + (b - a) * t


def lerp_color(c1, c2, t):
    return tuple(int(lerp(c1[i], c2[i], t)) for i in range(3))


def make_gradient_bg(width, height, c_top, c_bottom, corner_radius=0):
    """Creates a vertical gradient RGBA image with optional rounded corners."""
    img = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    pixels = img.load()

    # Build gradient pixel by pixel
    for y in range(height):
        t = y / (height - 1)
        color = lerp_color(c_top, c_bottom, t) + (255,)
        for x in range(width):
            pixels[x, y] = color

    if corner_radius > 0:
        mask = Image.new("L", (width, height), 0)
        ImageDraw.Draw(mask).rounded_rectangle(
            [0, 0, width - 1, height - 1], radius=corner_radius, fill=255
        )
        img.putalpha(mask)

    return img


def draw_sync_arrows(draw, cx, cy, radius, stroke, color):
    """Draw two circular sync arrows (refresh symbol) centred at cx, cy."""

    def thick_arc(start_deg, end_deg):
        for delta in range(-stroke // 2, stroke // 2 + 1):
            r = radius + delta
            if r <= 0:
                continue
            draw.arc(
                [cx - r, cy - r, cx + r, cy + r],
                start=start_deg,
                end=end_deg,
                fill=color,
                width=1,
            )

    # Arc 1: right half  (clockwise, 300° → 120°  = 180° sweep)
    thick_arc(-60, 120)
    # Arc 2: left half  (clockwise, 120° → 300°  = 180° sweep)
    thick_arc(120, 300)

    def arrowhead(angle_deg, clockwise, size):
        angle = math.radians(angle_deg)
        px = cx + radius * math.cos(angle)
        py = cy + radius * math.sin(angle)
        sign = 1 if clockwise else -1
        tx = -math.sin(angle) * sign
        ty = math.cos(angle) * sign
        nx = -math.cos(angle)
        ny = -math.sin(angle)

        tip = (px + tx * size * 0.6, py + ty * size * 0.6)
        b1 = (
            px - tx * size * 0.4 + nx * size * 0.45,
            py - ty * size * 0.4 + ny * size * 0.45,
        )
        b2 = (
            px - tx * size * 0.4 - nx * size * 0.45,
            py - ty * size * 0.4 - ny * size * 0.45,
        )
        draw.polygon([tip, b1, b2], fill=color)

    arrowhead(120, clockwise=True, size=stroke * 2.2)
    arrowhead(300, clockwise=True, size=stroke * 2.2)


def draw_cart(draw, cx, cy, scale, color):
    """
    Draw a clean shopping cart centred at (cx, cy).
    scale=1.0 → designed for a ~700px wide space inside 1024.
    """
    s = scale

    # ── basket ──────────────────────────────────────────────
    bw = int(420 * s)
    bh = int(230 * s)
    bx1 = cx - bw // 2
    by1 = cy - int(20 * s)
    bx2 = cx + bw // 2
    by2 = by1 + bh
    draw.rounded_rectangle([bx1, by1, bx2, by2], radius=int(32 * s), fill=color)

    # ── left pole (vertical) ────────────────────────────────
    pw = int(30 * s)
    pole_x = bx1 + int(50 * s)
    pole_top = by1 - int(200 * s)
    draw.rounded_rectangle(
        [pole_x - pw // 2, pole_top, pole_x + pw // 2, by1 + pw // 2],
        radius=pw // 2,
        fill=color,
    )

    # ── top handle bar (horizontal) ─────────────────────────
    bar_y = pole_top + pw // 2
    bar_x2 = bx2 - int(50 * s)
    draw.rounded_rectangle(
        [pole_x, bar_y - pw // 2, bar_x2, bar_y + pw // 2],
        radius=pw // 2,
        fill=color,
    )

    # ── wheels ───────────────────────────────────────────────
    wr = int(52 * s)  # outer radius
    wi = int(20 * s)  # inner hole radius
    wy = by2 + int(28 * s) + wr
    wx1 = bx1 + int(90 * s)
    wx2 = bx2 - int(90 * s)

    for wx in (wx1, wx2):
        draw.ellipse([wx - wr, wy - wr, wx + wr, wy + wr], fill=color)


def create_app_icon(out_path):
    C_TOP = (15, 84, 198)     # #0F54C6  deep blue
    C_BOT = (0, 180, 216)     # #00B4D8  bright cyan

    img = make_gradient_bg(SIZE, SIZE, C_TOP, C_BOT, corner_radius=200)
    draw = ImageDraw.Draw(img)

    # Cart – centred, nudged slightly up to leave room for wheels
    draw_cart(draw, cx=512, cy=490, scale=1.0, color=WHITE)

    # Sync badge – top-right quadrant
    draw_sync_arrows(draw, cx=730, cy=240, radius=90, stroke=28, color=WHITE)

    # Save full-resolution source icon
    img.save(out_path, "PNG")
    print(f"  Icon saved → {out_path}")
    return img


def create_feature_graphic(out_path):
    """1024 × 500 Play Store feature graphic."""
    W, H = 1024, 500
    C_TOP = (15, 84, 198)
    C_BOT = (0, 180, 216)

    img = make_gradient_bg(W, H, C_TOP, C_BOT, corner_radius=0)
    draw = ImageDraw.Draw(img)

    # Cart on the right side
    draw_cart(draw, cx=700, cy=270, scale=0.75, color=(255, 255, 255, 200))

    # Sync symbol, left-centre
    draw_sync_arrows(draw, cx=280, cy=240, radius=70, stroke=22, color=WHITE)

    # App name text
    try:
        from PIL import ImageFont
        font_large = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 90)
        font_small = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 36)
    except Exception:
        font_large = ImageFont.load_default()
        font_small = font_large

    draw.text((90, 130), "Cart Sync", fill=WHITE, font=font_large)
    draw.text((95, 235), "Shop together, in real time.", fill=(200, 235, 255), font=font_small)

    img.save(out_path, "PNG")
    print(f"  Feature graphic saved → {out_path}")


if __name__ == "__main__":
    base = os.path.dirname(os.path.abspath(__file__))
    icon_path = os.path.join(base, "icon", "icon.png")
    feature_path = os.path.join(base, "store", "feature_graphic.png")

    print("Generating Cart Sync assets…")
    create_app_icon(icon_path)
    create_feature_graphic(feature_path)
    print("Done.")
