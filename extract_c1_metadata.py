import json

with open('assets/data/c1.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

metadata = {
    "title": data["title"],
    "description": data["description"],
    "units": []
}

for unit in data["units"]:
    u_info = {
        "id": unit["id"],
        "title": unit["title"],
        "description": unit["description"],
        "lessons": []
    }
    for lesson in unit["lessons"]:
        u_info["lessons"].append({
            "id": lesson["id"],
            "title": lesson["title"]
        })
    metadata["units"].append(u_info)

with open('c1_metadata_original.json', 'w', encoding='utf-8') as f:
    json.dump(metadata, f, ensure_ascii=False, indent=4)

print("Extraction complete.")
