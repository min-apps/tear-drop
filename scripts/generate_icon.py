#!/usr/bin/env python3
"""Generate Teary app icon — clean teardrop on soft gradient background."""

from PIL import Image, ImageDraw, ImageFilter
import math
import os

SIZE = 1024

BG_TOP = (240, 247, 255)
BG_BOTTOM = (219, 234, 254)
DROP_TOP = (96, 165, 250)
DROP_MID = (37, 99, 235)
DROP_BOTTOM = (30, 64, 175)


def lerp_color(c1, c2, t):
    t = max(0.0, min(1.0, t))
    return tuple(int(c1[i] + (c2[i] - c1[i]) * t) for i in range(3))


def teardrop_outline(cx, cy, w, h, n=800):
    """
    Simple symmetric teardrop: for each y from tip to bottom,
    compute the x-width using a smooth function.

    At the tip (y=0): width = 0
    As y increases: width grows cubically then transitions to circular
    At the bottom: semicircular cap
    """
    points_right = []
    points_left = []

    tip_y = cy - h * 0.5
    bottom_y = cy + h * 0.5
    total_h = h

    # Radius of the circular bottom
    r = w * 0.5

    # The circular part starts at this y (center of circle)
    circle_cy = bottom_y - r

    for i in range(n + 1):
        y = tip_y + total_h * i / n

        if y <= circle_cy:
            # Above circle center: curve from pointed tip to circle body
            # Normalize: 0 at tip, 1 at circle_cy
            t = (y - tip_y) / (circle_cy - tip_y) if circle_cy > tip_y else 0
            # 1-(1-t)^p: pointed at tip (nonzero derivative), smooth at junction
            # (derivative → 0 at t=1, matching the circle's horizontal tangent)
            half_w = r * (1 - (1 - t) ** 2.2)
        else:
            # Below circle center: circular cap
            dy = y - circle_cy
            if dy <= r:
                half_w = math.sqrt(r * r - dy * dy)
            else:
                half_w = 0

        points_right.append((cx + half_w, y))
        points_left.append((cx - half_w, y))

    # Combine: right side top-to-bottom, then left side bottom-to-top
    points_left.reverse()
    return points_right + points_left


def draw_gradient_bg(img):
    draw = ImageDraw.Draw(img)
    for y in range(SIZE):
        t = y / SIZE
        draw.line([(0, y), (SIZE, y)], fill=lerp_color(BG_TOP, BG_BOTTOM, t))


def draw_drop(img, cx, cy, w, h):
    points = teardrop_outline(cx, cy, w, h)

    mask = Image.new('L', (SIZE, SIZE), 0)
    ImageDraw.Draw(mask).polygon(points, fill=255)
    mask = mask.filter(ImageFilter.GaussianBlur(radius=1.5))

    ys = [p[1] for p in points]
    min_y, max_y = int(min(ys)), int(max(ys))

    # Vertical gradient fill
    fill = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    fd = ImageDraw.Draw(fill)
    for y in range(min_y - 2, max_y + 3):
        t = (y - min_y) / (max_y - min_y) if max_y > min_y else 0
        if t < 0.35:
            c = lerp_color(DROP_TOP, DROP_MID, t / 0.35)
        else:
            c = lerp_color(DROP_MID, DROP_BOTTOM, (t - 0.35) / 0.65)
        fd.line([(0, y), (SIZE, y)], fill=(*c, 255))

    drop = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    drop.paste(fill, mask=mask)

    # Large soft glossy highlight (upper-left area of body)
    gloss = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    gd = ImageDraw.Draw(gloss)
    gx, gy = cx - w * 0.12, cy - h * 0.04
    gw, gh = w * 0.18, h * 0.2
    gd.ellipse([gx - gw, gy - gh, gx + gw, gy + gh], fill=(255, 255, 255, 55))
    gloss = gloss.filter(ImageFilter.GaussianBlur(radius=32))

    # Small bright specular dot
    spec = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    sd = ImageDraw.Draw(spec)
    sx, sy = cx - w * 0.14, cy - h * 0.08
    sr = w * 0.04
    sd.ellipse([sx - sr, sy - sr, sx + sr, sy + sr], fill=(255, 255, 255, 110))
    spec = spec.filter(ImageFilter.GaussianBlur(radius=6))

    drop = Image.alpha_composite(drop, gloss)
    drop = Image.alpha_composite(drop, spec)
    img.paste(drop, mask=drop.split()[3])


def draw_shadow(img, cx, cy, w, h):
    shadow = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sy = cy + h * 0.52
    sw, sh = w * 0.18, w * 0.03
    sd.ellipse([cx - sw, sy - sh, cx + sw, sy + sh], fill=(30, 64, 175, 25))
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=14))
    img.paste(shadow, mask=shadow.split()[3])


def generate_icon():
    img = Image.new('RGB', (SIZE, SIZE), BG_TOP)
    draw_gradient_bg(img)
    img = img.convert('RGBA')

    cx = SIZE // 2
    cy = int(SIZE * 0.47)
    w = int(SIZE * 0.42)
    h = int(SIZE * 0.60)

    draw_shadow(img, cx, cy, w, h)
    draw_drop(img, cx, cy, w, h)

    final = Image.new('RGB', (SIZE, SIZE), (255, 255, 255))
    final.paste(img, mask=img.split()[3])
    return final


def save_icons(icon):
    base = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    master = os.path.join(base, 'assets', 'icon', 'teary_icon.png')
    os.makedirs(os.path.dirname(master), exist_ok=True)
    icon.save(master, 'PNG')
    print(f"  Master: {master}")

    ios_dir = os.path.join(base, 'ios', 'Runner', 'Assets.xcassets',
                           'AppIcon.appiconset')
    ios = {
        'Icon-App-20x20@1x.png': 20, 'Icon-App-20x20@2x.png': 40,
        'Icon-App-20x20@3x.png': 60, 'Icon-App-29x29@1x.png': 29,
        'Icon-App-29x29@2x.png': 58, 'Icon-App-29x29@3x.png': 87,
        'Icon-App-40x40@1x.png': 40, 'Icon-App-40x40@2x.png': 80,
        'Icon-App-40x40@3x.png': 120, 'Icon-App-60x60@2x.png': 120,
        'Icon-App-60x60@3x.png': 180, 'Icon-App-76x76@1x.png': 76,
        'Icon-App-76x76@2x.png': 152, 'Icon-App-83.5x83.5@2x.png': 167,
        'Icon-App-1024x1024@1x.png': 1024,
    }
    for f, s in ios.items():
        icon.resize((s, s), Image.LANCZOS).save(os.path.join(ios_dir, f), 'PNG')
    print(f"  iOS: {len(ios)} icons")

    android_dir = os.path.join(base, 'android', 'app', 'src', 'main', 'res')
    android = {
        'mipmap-mdpi': 48, 'mipmap-hdpi': 72, 'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144, 'mipmap-xxxhdpi': 192,
    }
    for folder, s in android.items():
        icon.resize((s, s), Image.LANCZOS).save(
            os.path.join(android_dir, folder, 'ic_launcher.png'), 'PNG')
    print(f"  Android: {len(android)} icons")

    web_dir = os.path.join(base, 'web')
    web = {
        'favicon.png': 32, 'icons/Icon-192.png': 192,
        'icons/Icon-512.png': 512, 'icons/Icon-maskable-192.png': 192,
        'icons/Icon-maskable-512.png': 512,
    }
    for f, s in web.items():
        icon.resize((s, s), Image.LANCZOS).save(os.path.join(web_dir, f), 'PNG')
    print(f"  Web: {len(web)} icons")


if __name__ == '__main__':
    print("Generating Teary app icon...")
    icon = generate_icon()
    save_icons(icon)
    print("Done!")
