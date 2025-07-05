import React, { useState, useEffect } from 'react';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';

// Fix default icon issues in Leaflet + Webpack
import iconUrl from 'leaflet/dist/images/marker-icon.png';
import iconShadowUrl from 'leaflet/dist/images/marker-shadow.png';

delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconUrl,
  shadowUrl: iconShadowUrl,
});

function App() {
  const [racks, setRacks] = useState([]);

  useEffect(() => {
    fetch('http://localhost:5000/api/bikeracks')
      .then(res => res.json())
      .then(data => 
        {console.log('Fetched racks:', data)
        setRacks(data)})
      
      .catch(err => console.error(err));
  }, []);

  return (
    <div>
      <h1>Montreal Bike Racks</h1>
      <MapContainer
        center={[45.5017, -73.5673]} // Center on Montreal
        zoom={12}
        style={{ height: '90vh', width: '100%' }}
      >
        <TileLayer
          attribution='&copy; <a href="https://osm.org/copyright">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />

        {racks.map((rack, idx) => (
          <Marker
            key={idx}
            position={[parseFloat(rack.latitude), parseFloat(rack.longitude)]}
          >
            <Popup>
              <strong>Park:</strong> {rack.park}<br />
              <strong>Territory:</strong> {rack.territory}
            </Popup>
          </Marker>
        ))}
      </MapContainer>
    </div>
  );
}

export default App;
