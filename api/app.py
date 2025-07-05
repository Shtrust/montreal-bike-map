from flask import Flask, jsonify
import csv

app = Flask(__name__)


def load_bike_racks():
    racks = []
    with open(
        "data/bike_racks.csv", newline="", encoding="cp1252", errors="ignore"
    ) as f:
        reader = csv.DictReader(f)
        for row in reader:
            racks.append(
                {
                    "id": row.get("INV_ID", ""),
                    "longitude": row.get("LONG", ""),
                    "latitude": row.get("LAT", ""),
                    "park": row.get("PARC", ""),
                    "territory": row.get("TERRITOIRE", ""),
                }
            )
    return racks


@app.route("/api/bikeracks")
def bike_racks():
    return jsonify(load_bike_racks())


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
