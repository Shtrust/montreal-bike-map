import React, { useEffect, useState } from 'react';

function App() {
  const [racks, setRacks] = useState([]);

  useEffect(() => {
    fetch('http://localhost:5000/api/bikeracks')
      .then(response => response.json())
      .then(data => setRacks(data.slice(0, 20))) // Limit to first 20 for now
      .catch(err => console.error(err));
  }, []);

  return (
    <div style={{ padding: '2rem' }}>
      <h1>Montreal Bike Racks</h1>
      <table border="1" cellPadding="5">
        <thead>
          <tr>
            <th>ID</th>
            <th>Longitude</th>
            <th>Latitude</th>
            <th>Park</th>
            <th>Territory</th>
          </tr>
        </thead>
        <tbody>
          {racks.map(rack => (
            <tr key={rack.id}>
              <td>{rack.id}</td>
              <td>{rack.longitude}</td>
              <td>{rack.latitude}</td>
              <td>{rack.park}</td>
              <td>{rack.territory}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default App;

