#!/usr/bin/env python3
"""
Crawl YouTube for sad/emotional/touching videos across multiple categories.
Uses yt-dlp for searching (no API key needed for search).
"""

import subprocess
import json
import sys
import time
import os

# Categories and their search queries
CATEGORIES = {
    "touching": {
        "title": "감동",
        "subtitle": "마음을 울리는 감동 영상",
        "emoji": "🥹",
        "queries": [
            "감동 영상 눈물",
            "감동적인 영상 모음",
            "감동 실화 영상",
            "눈물나는 감동 영상",
            "감동 영상 레전드",
            "touching moments that make you cry",
            "most emotional videos ever",
            "heartwarming videos that will make you cry",
            "try not to cry challenge emotional",
            "감동 몰카",
        ],
    },
    "farewell": {
        "title": "이별",
        "subtitle": "이별의 아픔을 담은 영상",
        "emoji": "💔",
        "queries": [
            "이별 노래 모음 슬픈",
            "슬픈 이별 영상",
            "이별 후 눈물",
            "헤어진 후 듣는 노래",
            "이별 감성 영상",
            "sad breakup songs that make you cry",
            "saddest farewell moments",
            "breakup songs playlist crying",
            "farewell songs emotional",
            "sad love songs that make you cry",
        ],
    },
    "animal": {
        "title": "동물",
        "subtitle": "동물과 사람의 따뜻한 이야기",
        "emoji": "🐾",
        "queries": [
            "동물 감동 영상 눈물",
            "강아지 재회 감동",
            "유기견 구조 감동",
            "동물 구조 영상",
            "반려동물 이별 눈물",
            "sad animal videos that make you cry",
            "dog reunion with owner crying",
            "emotional animal rescue",
            "soldier dog reunion",
            "pets saying goodbye emotional",
        ],
    },
    "family": {
        "title": "가족",
        "subtitle": "가족의 사랑과 희생",
        "emoji": "👨‍👩‍👧‍👦",
        "queries": [
            "가족 감동 영상 눈물",
            "부모님 감동 몰카",
            "아빠 딸 감동",
            "엄마 감동 영상",
            "부모님 서프라이즈 감동",
            "family reunion emotional surprise",
            "soldier homecoming surprise family",
            "father daughter emotional moments",
            "parents surprise reaction crying",
            "most emotional family reunions",
        ],
    },
    "sacrifice": {
        "title": "희생",
        "subtitle": "숭고한 희생의 이야기",
        "emoji": "🫡",
        "queries": [
            "희생 감동 영상",
            "소방관 감동 구조",
            "군인 감동 영상",
            "영웅적 희생 실화",
            "감동 실화 희생",
            "heroic sacrifice stories that make you cry",
            "firefighter emotional rescue",
            "soldier sacrifice emotional",
            "acts of kindness that make you cry",
            "selfless heroes emotional moments",
        ],
    },
    "music": {
        "title": "음악",
        "subtitle": "눈물이 나는 음악",
        "emoji": "🎵",
        "queries": [
            "슬픈 노래 모음 눈물",
            "눈물나는 노래 모음",
            "감성 발라드 모음",
            "이별 노래 눈물",
            "슬픈 피아노 음악",
            "saddest songs ever that make you cry",
            "songs that will make you cry",
            "most emotional music ever",
            "sad piano music crying",
            "emotional songs compilation",
        ],
    },
    "movie": {
        "title": "영화",
        "subtitle": "영화 속 눈물의 명장면",
        "emoji": "🎬",
        "queries": [
            "영화 명장면 눈물",
            "영화 감동 장면 모음",
            "슬픈 영화 장면",
            "영화 엔딩 눈물",
            "한국영화 감동 장면",
            "saddest movie scenes of all time",
            "movie scenes that will make you cry",
            "most emotional movie moments",
            "saddest anime scenes",
            "kdrama sad scenes that make you cry",
        ],
    },
}


def search_youtube(query, max_results=20):
    """Search YouTube using yt-dlp and return video metadata."""
    try:
        result = subprocess.run(
            [
                "python3", "-m", "yt_dlp",
                "--flat-playlist",
                "--dump-json",
                f"ytsearch{max_results}:{query}",
            ],
            capture_output=True,
            text=True,
            timeout=60,
        )
        videos = []
        for line in result.stdout.strip().split("\n"):
            if not line:
                continue
            try:
                d = json.loads(line)
                videos.append({
                    "id": d.get("id", ""),
                    "title": d.get("title", ""),
                    "channel": d.get("channel", d.get("uploader", "")),
                    "view_count": d.get("view_count", 0),
                    "duration": d.get("duration", 0),
                })
            except json.JSONDecodeError:
                continue
        return videos
    except subprocess.TimeoutExpired:
        print(f"  TIMEOUT: {query}", file=sys.stderr)
        return []
    except Exception as e:
        print(f"  ERROR: {query}: {e}", file=sys.stderr)
        return []


def get_video_details(video_ids):
    """Get detailed info for specific video IDs using yt-dlp."""
    details = {}
    for vid in video_ids:
        try:
            result = subprocess.run(
                [
                    "python3", "-m", "yt_dlp",
                    "--dump-json",
                    "--skip-download",
                    f"https://www.youtube.com/watch?v={vid}",
                ],
                capture_output=True,
                text=True,
                timeout=30,
            )
            if result.stdout.strip():
                d = json.loads(result.stdout.strip())
                details[vid] = {
                    "id": vid,
                    "title": d.get("title", ""),
                    "channel": d.get("channel", d.get("uploader", "")),
                    "view_count": d.get("view_count", 0),
                    "duration": d.get("duration", 0),
                }
        except Exception as e:
            print(f"  Error getting details for {vid}: {e}", file=sys.stderr)
    return details


def main():
    all_videos = {}  # category -> list of video dicts
    seen_ids = set()

    for cat_id, cat_info in CATEGORIES.items():
        print(f"\n{'='*60}", file=sys.stderr)
        print(f"Category: {cat_info['title']} ({cat_id})", file=sys.stderr)
        print(f"{'='*60}", file=sys.stderr)

        cat_videos = []

        for i, query in enumerate(cat_info["queries"]):
            print(f"  [{i+1}/{len(cat_info['queries'])}] Searching: {query}", file=sys.stderr)
            results = search_youtube(query, max_results=15)
            print(f"    Found {len(results)} results", file=sys.stderr)

            for v in results:
                vid = v["id"]
                if not vid or vid in seen_ids:
                    continue

                # Filter: duration between 60s and 1200s (1-20 min)
                duration = v.get("duration") or 0
                if duration < 60 or duration > 1200:
                    continue

                # Filter: views > 100K (but be lenient for flat-playlist which may not have view_count)
                view_count = v.get("view_count") or 0
                if view_count > 0 and view_count < 100000:
                    continue

                seen_ids.add(vid)
                cat_videos.append(v)

            # Small delay to avoid rate limiting
            time.sleep(1)

        all_videos[cat_id] = cat_videos
        print(f"  Total unique videos for {cat_id}: {len(cat_videos)}", file=sys.stderr)

    # Output as JSON
    output = {}
    for cat_id, cat_info in CATEGORIES.items():
        output[cat_id] = {
            "title": cat_info["title"],
            "subtitle": cat_info["subtitle"],
            "emoji": cat_info["emoji"],
            "videos": all_videos.get(cat_id, []),
        }

    print(json.dumps(output, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
